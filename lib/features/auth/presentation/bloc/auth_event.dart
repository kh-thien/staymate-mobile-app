abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class AuthStateChanged extends AuthEvent {}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmail({required this.email, required this.password});
}

class SignInWithGoogle extends AuthEvent {}

class SignUpWithGoogle extends AuthEvent {}

class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  SignUpWithEmail({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class SignOut extends AuthEvent {}

class ClearError extends AuthEvent {}
