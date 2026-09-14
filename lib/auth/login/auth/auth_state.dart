import 'package:equatable/equatable.dart';
import '../../../models/UserModel.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {}

/// Loading state
class AuthLoading extends AuthState {}

/// User successfully authenticated
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// No user is logged in
class AuthUnauthenticated extends AuthState {}

/// Authentication operation failed
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Operation completed successfully
///
/// Used mainly for Forgot Password because
/// we don't want to navigate to the authenticated
/// part of the app after sending a reset email.
class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}