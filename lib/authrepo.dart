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

  // ----------------------------------------------------------
  // GET CURRENT USER
  // ----------------------------------------------------------

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  // ----------------------------------------------------------
  // SIGNUP
  // ----------------------------------------------------------

  Future<UserModel> signup({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception('Account creation failed.');
      }

      // Save basic user information in Firestore.
      await _firestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'email': user.email ?? email.trim(),
          'name': user.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return UserModel(
        uid: user.uid,
        email: user.email ?? email.trim(),
        name: user.displayName ?? '',
      );
    } on FirebaseAuthException {
      // IMPORTANT:
      // Do NOT convert FirebaseAuthException to a normal Exception here.
      //
      // The AuthBloc needs to receive FirebaseAuthException so that
      // it can check:
      //
      // e.code == 'email-already-in-use'
      //
      // and then try login.
      rethrow;
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ----------------------------------------------------------
  // LOGIN
  // ----------------------------------------------------------

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception('Login failed.');
      }

      return UserModel(
        uid: user.uid,
        email: user.email ?? email.trim(),
        name: user.displayName ?? '',
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ----------------------------------------------------------
  // RESET PASSWORD
  // ----------------------------------------------------------

  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ----------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}