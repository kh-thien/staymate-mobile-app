import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const StayMateApp());
}

class StayMateApp extends StatelessWidget {
  const StayMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        // TODO: Add more routes here
        // '/register': (context) => const RegisterPage(),
        // '/home': (context) => const HomePage(),
      },
    );
  }
}
