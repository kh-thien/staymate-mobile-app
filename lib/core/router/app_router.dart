import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class AppRouter {
  static const String home = '/';
  static const String tracking = '/tracking';
  static const String chat = '/chat';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: Colors.amberAccent,
            appBar: const CustomAppBar(),
            body: Stack(
              children: [
                // Main Content
                child,

                // Floating Bottom Navigation Bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: const CustomBottomNav(),
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: tracking,
            name: 'tracking',
            builder: (context, state) => const TrackingPage(),
          ),
          GoRoute(
            path: chat,
            name: 'chat',
            builder: (context, state) => const ChatPage(),
          ),
        ],
      ),
    ],
  );
}
