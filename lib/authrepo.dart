import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/UserModel.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;



  static const String _webClientId =
      '298495645162-ikfrnuso53q79l16295hp158n4fmft72.apps.googleusercontent.com';

  // Google Sign-In v7 must be initialized exactly once.
  Future<void>? _googleInit;

  Future<void> _ensureGoogleInitialized() {
    if (_webClientId.startsWith('PASTE_YOUR_WEB_CLIENT_ID')) {
      throw Exception(
        'Google sign-in is not configured: set _webClientId in authrepo.dart.',
      );
    }

    return _googleInit ??= GoogleSignIn.instance
        .initialize(serverClientId: _webClientId)
        .catchError((Object e) {
      // Allow a retry if initialization failed.
      _googleInit = null;
      throw e;
    });
  }

  // ----------------------------------------------------------
  // FIREBASE USER -> UserModel
  //
  // The ONE place that builds your UserModel.
  // ----------------------------------------------------------

  UserModel _toUserModel(User user) {
    final email = user.email ?? '';
    final displayName = user.displayName?.trim() ?? '';

    final name = displayName.isNotEmpty
        ? displayName
        : (email.contains('@') ? email.split('@').first : 'User');

    return UserModel(
      uid: user.uid,
      email: email,
      name: name,
    );
  }

  // ----------------------------------------------------------
  // CURRENT USER
  // ----------------------------------------------------------

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _toUserModel(user);
  }

  // ----------------------------------------------------------
  // EMAIL LOGIN
  // ----------------------------------------------------------

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toUserModel(result.user!);
  }

  // ----------------------------------------------------------
  // EMAIL SIGNUP
  // ----------------------------------------------------------

  Future<UserModel> signup({
    required String email,
    required String password,
  }) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toUserModel(result.user!);
  }

  // ----------------------------------------------------------
  // GOOGLE SIGN-IN
  // ----------------------------------------------------------

  Future<UserModel> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    final googleSignIn = GoogleSignIn.instance;

    if (!googleSignIn.supportsAuthenticate()) {
      throw Exception('Google sign-in is not supported on this platform.');
    }

    // Opens the Google account picker.
    final GoogleSignInAccount googleUser;
    try {
      googleUser = await googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      // Shows the real reason in the Flutter console while testing.
      debugPrint(
        'GoogleSignInException -> code: ${e.code}, '
            'description: ${e.description}, details: ${e.details}',
      );
      rethrow;
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw Exception(
        'Google did not return an ID token. '
            'Check that _webClientId is the WEB client ID.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    // Creates the Firebase account automatically on first Google login.
    final result = await _firebaseAuth.signInWithCredential(credential);

    return _toUserModel(result.user!);
  }

  // ----------------------------------------------------------
  // RESET PASSWORD
  // ----------------------------------------------------------

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ----------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------

  Future<void> logout() async {
    // Sign out of Google too, so the account picker shows next time.
    try {
      await _ensureGoogleInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Ignore: user may not have signed in with Google.
    }

    await _firebaseAuth.signOut();
  }
}