import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthBlocState {}

class AuthInitial extends AuthBlocState {}

class AuthLoading extends AuthBlocState {}

class AuthAuthenticated extends AuthBlocState {
  final User user;
  final String displayName;

  AuthAuthenticated({required this.user, required this.displayName});
}

class AuthUnauthenticated extends AuthBlocState {}

class AuthError extends AuthBlocState {
  final String message;
  final String? code;

  AuthError({required this.message, this.code});
}

// Specific loading states for better UX
class AuthSigningIn extends AuthBlocState {}

class AuthSigningUp extends AuthBlocState {}

class AuthSigningOut extends AuthBlocState {}

// Success states
class AuthSignUpSuccess extends AuthBlocState {
  final User user;
  final String displayName;

  AuthSignUpSuccess({required this.user, required this.displayName});
}

// Email confirmation required state
class AuthEmailConfirmationRequired extends AuthBlocState {
  final String email;
  final String message;

  AuthEmailConfirmationRequired({
    required this.email,
    this.message =
        'Vui lòng kiểm tra email và xác nhận tài khoản trước khi đăng nhập.',
  });
}
