import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authrepo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckedRequested>(_onCheckRequested);
    on<AuthLoginOrSignupRequested>(_onLoginOrSignupRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // ----------------------------------------------------------
  // CHECK CURRENT USER
  // ----------------------------------------------------------

  Future<void> _onCheckRequested(
      AuthCheckedRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.getCurrentUser();

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(
        AuthFailure(
          _cleanErrorMessage(e),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // CREATE ACCOUNT FIRST
  // IF EMAIL EXISTS -> LOGIN
  // ----------------------------------------------------------

  Future<void> _onLoginOrSignupRequested(
      AuthLoginOrSignupRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final email = event.email.trim();
    final password = event.password;

    try {
      // STEP 1:
      // Try to create a new Firebase account first.
      final user = await authRepository.signup(
        email: email,
        password: password,
      );

      // Account successfully created.
      emit(AuthAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      // STEP 2:
      // If Firebase says that this email is already registered,
      // automatically try to login.
      if (e.code == 'email-already-in-use') {
        try {
          final user = await authRepository.login(
            email: email,
            password: password,
          );

          // Login successful.
          emit(AuthAuthenticated(user));
        } catch (loginError) {
          // Login failed.
          emit(
            AuthFailure(
              _cleanErrorMessage(loginError),
            ),
          );
        }
      } else {
        // Signup failed for another reason.
        emit(
          AuthFailure(
            _cleanErrorMessage(e),
          ),
        );
      }
    } catch (e) {
      emit(
        AuthFailure(
          _cleanErrorMessage(e),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // NORMAL LOGIN
  // ----------------------------------------------------------

  Future<void> _onLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.login(
        email: event.email.trim(),
        password: event.password,
      );

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(
        AuthFailure(
          _cleanErrorMessage(e),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // NORMAL SIGNUP
  // ----------------------------------------------------------

  Future<void> _onSignupRequested(
      AuthSignupRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.signup(
        email: event.email.trim(),
        password: event.password,
      );

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(
        AuthFailure(
          _cleanErrorMessage(e),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // FORGOT PASSWORD
  // ----------------------------------------------------------

  Future<void> _onForgotPasswordRequested(
      AuthForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    final email = event.email.trim();

    if (email.isEmpty) {
      emit(
        const AuthFailure(
          'Please enter your email.',
        ),
      );
      return;
    }

    emit(AuthLoading());

    try {
      await authRepository.resetPassword(
        email: email,
      );

      emit(
        const AuthSuccess(
          'Password reset email sent. Please check your inbox.',
        ),
      );
    } catch (e) {
      emit(
        AuthFailure(
          _cleanErrorMessage(e),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      await authRepository.logout();

      emit(AuthUnauthenticated());
    } catch (e) {
      emit(
        AuthFailure(
          _cleanErrorMessage(e),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // ERROR MESSAGE HELPER
  // ----------------------------------------------------------

  String _cleanErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is invalid.';

        case 'weak-password':
          return 'The password is too weak.';

        case 'user-not-found':
          return 'No account found with this email.';

        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';

        case 'email-already-in-use':
          return 'This email is already in use.';

        case 'network-request-failed':
          return 'Please check your internet connection.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        case 'user-disabled':
          return 'This account has been disabled.';

        default:
          return error.message ?? 'Authentication failed.';
      }
    }

    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }
}