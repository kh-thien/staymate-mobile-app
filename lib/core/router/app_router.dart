import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_state_notifier.dart';
import 'package:stay_mate/features/invoice/presentation/pages/invoice_page.dart';
import 'package:stay_mate/features/report/presentation/pages/report_page.dart';
import 'package:stay_mate/features/report/presentation/pages/create_report_page.dart';
import 'package:stay_mate/features/report/presentation/pages/report_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/contract/presentation/pages/contract_page.dart';
import '../../features/contract/presentation/pages/contract_detail_page.dart';
import '../../features/contract/presentation/providers/contract_detail_cubit.dart';
import '../../features/contract/domain/usecases/get_contract_detail_usecase.dart';
import '../../features/contract/data/repositories/contract_repository_impl.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import '../guards/auth_guard.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/profile/presentation/pages/notification_settings_page.dart';
import '../../features/home/presentation/pages/notifications_page.dart';

class AppRouter {
  static const String home = '/';
  static const String auth = '/auth';
  static const String contract = '/contract';
  static const String contractDetail = '/contract/:id';
  static const String chat = '/chat';
  static const String chatDetail = '/chat/:roomId';
  static const String invoice = '/invoice';
  static const String invoiceDetail = '/invoice/:invoiceId';
  static const String report = '/report';
  static const String notificationSettings = '/notification-settings';
  static const String notifications = '/notifications';

  static GoRouter createRouter(AuthStateNotifier authStateNotifier) {

    return GoRouter(
      initialLocation: auth,
      refreshListenable: authStateNotifier,
      redirect: (context, state) {
        // Nếu AuthBloc đang check hoặc loading, đợi kết quả
        if (authStateNotifier.isInitialOrLoading) {
          return null; // Không redirect, đợi AuthBloc check xong
        }

        final isAuthenticated = authStateNotifier.isAuthenticated;
        final isAuthRoute = state.uri.path == auth;

        // Nếu đang ở auth route và đã đăng nhập, redirect đến home
        if (isAuthRoute && isAuthenticated) {
          return home;
        }

        // Nếu không phải auth route và chưa đăng nhập, redirect đến auth
        // (AuthGuard sẽ handle authentication check for protected routes)
        if (!isAuthRoute && !isAuthenticated) {
          return auth;
        }

        return null; // Không redirect
      },
      routes: _buildRoutes(),
    );
  }

  static List<RouteBase> _buildRoutes() {
    return [
      // Auth route - Public (no auth required)
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) {
          final isSignUp = state.uri.queryParameters['tab'] == 'signup';
          return AuthPage(initialIsSignIn: !isSignUp);
        },
      ),
      // Protected routes - Require authentication (including home)
      ShellRoute(
        builder: (context, state, child) {
          final topSafeArea = MediaQuery.of(context).padding.top;
          // Height = safe area + logo (56) + padding (8*2) = safe area + 72
          final appBarHeight = topSafeArea + 72.0;
          
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.amberAccent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight),
              child: const CustomAppBar(),
            ),
            body: Stack(
              children: [
                // Main Content with AuthGuard
                child,
                // Floating Bottom Navigation Bar
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNav(),
                ),
              ],
            ),
          );
        },
        routes: [
          // Home route
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const AuthGuard(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: contract,
            name: 'contract',
            builder: (context, state) => const AuthGuard(
              child: ContractPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: 'contractDetail',
                builder: (context, state) {
                  final contractId = state.pathParameters['id']!;
                  // Create cubit with dependencies
                  final repository = ContractRepositoryImpl();
                  final useCase = GetContractDetailUseCase(repository);
                  final cubit = ContractDetailCubit(
                    getContractDetailUseCase: useCase,
                  );
                  return AuthGuard(
                    child: ContractDetailPage(
                    contractId: contractId,
                    cubit: cubit,
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: chat,
            name: 'chat',
            builder: (context, state) => const AuthGuard(
              child: ChatListPage(),
            ),
            routes: [
              GoRoute(
                path: ':roomId',
                name: 'chatDetail',
                builder: (context, state) {
                  final roomId = state.pathParameters['roomId']!;
                  return AuthGuard(
                    child: ChatDetailPage(roomId: roomId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: invoice,
            name: 'invoice',
            builder: (context, state) => const AuthGuard(
              child: InvoicePage(),
            ),
          ),
          GoRoute(
            path: report,
            name: 'report',
            builder: (context, state) => const AuthGuard(
              child: ReportPage(),
            ),
            routes: [
              GoRoute(
                path: 'create',
                name: 'createReport',
                builder: (context, state) => const AuthGuard(
                  child: CreateReportPage(),
                ),
              ),
              GoRoute(
                path: ':id',
                name: 'reportDetail',
                builder: (context, state) {
                  final reportId = state.pathParameters['id']!;
                  return AuthGuard(
                    child: ReportDetailPage(reportId: reportId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: notificationSettings,
            name: 'notificationSettings',
            builder: (context, state) => const AuthGuard(
              child: NotificationSettingsPage(),
            ),
          ),
        ],
      ),
      // Notification page - Full screen (not in ShellRoute)
      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const AuthGuard(
          child: NotificationsPage(),
        ),
      ),
    ];
  }
}
