import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';

/// Widget để bảo vệ các routes cần authentication
/// Redirect đến auth page nếu user chưa đăng nhập
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        // Nếu chưa đăng nhập và không phải đang loading, redirect đến auth
        if (state is! AuthAuthenticated &&
            state is! AuthInitial &&
            state is! AuthLoading) {
          // Delay một chút để tránh rebuild loop
          Future.microtask(() {
            if (context.mounted) {
              context.go('/auth');
            }
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          // Đang kiểm tra auth status
          if (state is AuthInitial || state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Đã đăng nhập - hiển thị content
          if (state is AuthAuthenticated) {
            return child;
          }

          // Chưa đăng nhập - hiển thị loading (sẽ redirect)
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

