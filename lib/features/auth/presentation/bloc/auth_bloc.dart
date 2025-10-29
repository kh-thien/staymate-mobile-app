import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// Auth Bloc
class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final AuthService _authService;
  StreamSubscription? _authSubscription;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignUpWithGoogle>(_onSignUpWithGoogle);
    on<SignUpWithEmail>(_onSignUpWithEmail);
    on<SignOut>(_onSignOut);
    on<ClearError>(_onClearError);

    // Listen to auth state changes
    _authSubscription = _authService.authStateChanges.listen((authState) {
      add(AuthStateChanged());
    });

    // Check initial auth status
    add(CheckAuthStatus());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      if (_authService.isLoggedIn) {
        final user = _authService.currentUser!;
        final displayName =
            user.userMetadata?['full_name'] as String? ??
            user.email?.split('@').first ??
            'User';

        emit(AuthAuthenticated(user: user, displayName: displayName));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check auth status: $e'));
    }
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      if (_authService.isLoggedIn) {
        final user = _authService.currentUser!;
        final displayName =
            user.userMetadata?['full_name'] as String? ??
            user.email?.split('@').first ??
            'User';

        emit(AuthAuthenticated(user: user, displayName: displayName));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Auth state change error: $e'));
    }
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthSigningIn());

      final response = await _authService.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        final displayName =
            response.user!.userMetadata?['full_name'] as String? ??
            response.user!.email?.split('@').first ??
            'User';

        emit(AuthAuthenticated(user: response.user!, displayName: displayName));
      } else {
        emit(AuthUnauthenticated());
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      emit(AuthError(message: 'Sign in failed: $e'));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthSigningIn());

      final response = await _authService.signInWithGoogle();

      if (response.user != null) {
        final displayName =
            response.user!.userMetadata?['full_name'] as String? ??
            response.user!.email?.split('@').first ??
            'User';

        emit(AuthAuthenticated(user: response.user!, displayName: displayName));
      } else {
        emit(AuthUnauthenticated());
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      emit(AuthError(message: 'Google sign in failed: $e'));
    }
  }

  Future<void> _onSignUpWithGoogle(
    SignUpWithGoogle event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthSigningUp());

      final response = await _authService.signInWithGoogle();

      if (response.user != null) {
        final displayName =
            response.user!.userMetadata?['full_name'] as String? ??
            response.user!.email?.split('@').first ??
            'User';

        emit(AuthSignUpSuccess(user: response.user!, displayName: displayName));
      } else {
        emit(AuthUnauthenticated());
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      emit(AuthError(message: 'Google sign up failed: $e'));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthBlocState> emit,
  ) async {
    try {
      emit(AuthSigningUp());

      final response = await _authService.signUpWithEmail(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      if (response.user != null) {
        emit(
          AuthSignUpSuccess(user: response.user!, displayName: event.fullName),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      emit(AuthError(message: 'Sign up failed: $e'));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthBlocState> emit) async {
    try {
      emit(AuthSigningOut());

      await _authService.signOut();

      emit(AuthUnauthenticated());
    } on AuthException catch (e) {
      emit(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      emit(AuthError(message: 'Sign out failed: $e'));
    }
  }

  Future<void> _onClearError(
    ClearError event,
    Emitter<AuthBlocState> emit,
  ) async {
    // Don't emit anything, just clear the error by going back to previous state
    if (state is AuthError) {
      add(CheckAuthStatus());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
