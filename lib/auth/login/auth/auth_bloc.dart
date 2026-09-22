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
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // ============================================================
  // CHECK CURRENT USER
  // ============================================================

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
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

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
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // ============================================================
  // SIGNUP
  // ============================================================

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
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> _onForgotPasswordRequested(
      AuthForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    final email = event.email.trim();

    // Check email before Firebase call
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
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

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
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}