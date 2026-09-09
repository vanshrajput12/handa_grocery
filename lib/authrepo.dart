import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/UserModel.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Checks if a user is already logged in
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }

  /// Logs in an existing user with email/password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // Get existing user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      String name = user.displayName ?? '';

      // If name is already saved in Firestore, use it
      if (userDoc.exists) {
        final data = userDoc.data();

        if (data != null && data['name'] != null) {
          name = data['name'].toString();
        }
      }

      // Save/update user information automatically
      await _firestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'name': name,
          'email': user.email ?? email,
        },
        SetOptions(merge: true),
      );

      return UserModel.fromFirebaseUser(
        user,
        name: name,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Creates a new account with name/email/password
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // Save name in Firebase Authentication
      await user.updateDisplayName(name);

      // Save name + email + UID in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': user.email ?? email,
      });

      return UserModel.fromFirebaseUser(
        user,
        name: name,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Logs the current user out
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Converts Firebase error codes into readable messages
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists for this email.';

      case 'weak-password':
        return 'Password is too weak (min 6 characters).';

      case 'invalid-email':
        return 'That email address looks invalid.';

      case 'user-disabled':
        return 'This account has been disabled.';

      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}