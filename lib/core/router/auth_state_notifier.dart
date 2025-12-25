import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';

/// Notifier để router có thể listen AuthBloc state changes
class AuthStateNotifier extends ChangeNotifier {
  AuthBlocState _state = AuthInitial();

  AuthBlocState get state => _state;

  void updateState(AuthBlocState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  bool get isAuthenticated => _state is AuthAuthenticated;
  bool get isInitialOrLoading =>
      _state is AuthInitial || _state is AuthLoading;
}

/// Widget để wrap app và update AuthStateNotifier khi AuthBloc state thay đổi
class AuthStateListener extends StatelessWidget {
  final Widget child;
  final AuthStateNotifier notifier;

  const AuthStateListener({
    super.key,
    required this.child,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        notifier.updateState(state);
      },
      child: child,
    );
  }
}

