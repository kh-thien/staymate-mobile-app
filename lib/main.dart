import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'features/auth/presentation/bloc/auth_bloc_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Suppress app_links plugin errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('app_links')) {
      return; // Ignore app_links errors
    }
    FlutterError.presentError(details);
  };

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
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
