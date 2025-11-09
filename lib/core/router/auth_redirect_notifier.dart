import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';

/// Notifier để router có thể listen auth state changes và redirect
class AuthRedirectNotifier extends ChangeNotifier {
  final BuildContext context;

  AuthRedirectNotifier(this.context) {
    // Listen to auth state changes
    context.read<AuthBloc>().stream.listen((state) {
      notifyListeners(); // Notify router to check redirect
    });
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    final state = context.read<AuthBloc>().state;
    return state is AuthAuthenticated;
  }
}

