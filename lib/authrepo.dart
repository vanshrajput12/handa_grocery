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

  // ============================================================
  // CHECK CURRENT USER
  // ============================================================

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim();

      // Validate before Firebase
      if (cleanEmail.isEmpty) {
        throw 'Please enter your email.';
      }

      if (password.isEmpty) {
        throw 'Please enter your password.';
      }

      final credential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = credential.user!;

      // Get existing user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      String name = user.displayName ?? '';

      if (userDoc.exists) {
        final data = userDoc.data();

        if (data != null && data['name'] != null) {
          name = data['name'].toString();
        }
      }

      // Save/update user information
      await _firestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'name': name,
          'email': user.email ?? cleanEmail,
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

  // ============================================================
  // SIGNUP
  // ============================================================

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cleanName = name.trim();
      final cleanEmail = email.trim();
      final cleanPassword = password;

      // Validate before Firebase
      if (cleanName.isEmpty) {
        throw 'Please enter your name.';
      }

      if (cleanEmail.isEmpty) {
        throw 'Please enter your email.';
      }

      if (cleanPassword.isEmpty) {
        throw 'Please enter your password.';
      }

      if (cleanPassword.length < 6) {
        throw 'Password must be at least 6 characters.';
      }

      final credential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: cleanPassword,
      );

      final user = credential.user!;

      // Save name in Firebase Authentication
      await user.updateDisplayName(cleanName);

      // Save name + email + UID in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': cleanName,
        'email': user.email ?? cleanEmail,
      });

      return UserModel.fromFirebaseUser(
        user,
        name: cleanName,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      final cleanEmail = email.trim();

      // IMPORTANT:
      // Don't send empty email to Firebase.
      if (cleanEmail.isEmpty) {
        throw 'Please enter your email.';
      }

      await _firebaseAuth.sendPasswordResetEmail(
        email: cleanEmail,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // ============================================================
  // FIREBASE ERROR MESSAGES
  // ============================================================

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

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}