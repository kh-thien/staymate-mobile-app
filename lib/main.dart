import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/bloc/auth_bloc_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Suppress app_links plugin errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('app_links')) {
      return; // Ignore app_links errors
    }
    FlutterError.presentError(details);
  };

  await Supabase.initialize(
    url: 'https://detjjoponbvlgzeglkty.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRldGpqb3BvbmJ2bGd6ZWdsa3R5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3NTQzNTQsImV4cCI6MjA3MjMzMDM1NH0.lqxIYETnfPdIwunjRF_vYa1SgKqRct-j_M83jamcoDM',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const StayMateApp());
}

class StayMateApp extends StatelessWidget {
  const StayMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc to the entire app
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(authService: AuthService())
                ..add(CheckAuthStatus()), // Check initial auth status
        ),
      ],
      child: MaterialApp.router(
        title: 'StayMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
