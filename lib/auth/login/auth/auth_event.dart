abstract class AuthEvent {}

/// Check whether a user is already logged in
class AuthCheckedRequested extends AuthEvent {}

/// Login with email and password
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

/// Create a new account
class AuthSignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignupRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

/// Send password reset email
class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({
    required this.email,
  });
}

/// Logout current user
class AuthLogoutRequested extends AuthEvent {}