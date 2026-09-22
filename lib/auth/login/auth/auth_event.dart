abstract class AuthEvent {
  const AuthEvent();
}

/// Check whether a user is already logged in.
class AuthCheckedRequested extends AuthEvent {
  const AuthCheckedRequested();
}

/// Try to create an account first.
/// If email already exists, AuthBloc will automatically try login.
class AuthLoginOrSignupRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginOrSignupRequested({
    required this.email,
    required this.password,
  });
}

/// Normal login event.
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

/// Normal signup event.
class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignupRequested({
    required this.email,
    required this.password,
  });
}

/// Forgot password event.
class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({
    required this.email,
  });
}

/// Logout event.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}