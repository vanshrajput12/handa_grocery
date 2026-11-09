import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/UserModel.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Google Sign-In v7 must be initialized once before first use.
  bool _googleInitialized = false;

  // Paste your WEB client ID here (Firebase Console > Authentication >
  // Sign-in method > Google > Web SDK configuration), or find it in
  // google-services.json under "oauth_client" with "client_type": 3.
  static const String _webClientId =
      'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  // ----------------------------------------------------------
  // FIREBASE USER -> UserModel
  //
  // IMPORTANT: this is the ONE place that builds your UserModel.
  // Make it match your UserModel constructor. If your existing
  // login()/signup() build UserModel differently, copy that here.
  // ----------------------------------------------------------

  UserModel _toUserModel(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '', name: 'U',
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
    final googleSignIn = GoogleSignIn.instance;

    if (!_googleInitialized) {
      await googleSignIn.initialize(serverClientId: _webClientId);
      _googleInitialized = true;
    }

    // Opens the Google account picker.
    final googleUser = await googleSignIn.authenticate();

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw Exception('Google sign-in failed. Please try again.');
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
      if (_googleInitialized) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {
      // Ignore: user may not have signed in with Google.
    }

    await _firebaseAuth.signOut();
  }
}