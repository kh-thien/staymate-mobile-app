import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_state_notifier.dart';
import '../constants/app_styles.dart';
import 'package:stay_mate/features/invoice/presentation/pages/invoice_page.dart';
import 'package:stay_mate/features/invoice/presentation/pages/invoice_detail_page.dart';
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
import '../../shared/widgets/connectivity_snackbar.dart';
import '../guards/auth_guard.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/profile/presentation/pages/notification_settings_page.dart';
import '../../features/profile/presentation/pages/language_settings_page.dart';
import '../../features/profile/presentation/pages/app_info_page.dart';
import '../../features/profile/presentation/pages/personal_info_page.dart';
import '../../features/profile/presentation/pages/account_settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/feedback/presentation/pages/feedback_page.dart';
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
  static const String languageSettings = '/language-settings';
  static const String notifications = '/notifications';
  static const String appInfo = '/app-info';
  static const String personalInfo = '/profile/personal-info';
  static const String accountSettings = '/profile/account';
  static const String onboarding = '/onboarding';
  static const String feedback = '/feedback';

  static GoRouter createRouter(AuthStateNotifier authStateNotifier) {

    return GoRouter(
      initialLocation: auth,
      refreshListenable: authStateNotifier,
      redirect: (context, state) async {
        // Nếu AuthBloc đang check hoặc loading, đợi kết quả
        if (authStateNotifier.isInitialOrLoading) {
          return null; // Không redirect, đợi AuthBloc check xong
        }

        final isAuthenticated = authStateNotifier.isAuthenticated;
        final isAuthRoute = state.uri.path == auth;
        final isOnboardingRoute = state.uri.path == onboarding;

        // Nếu đang ở auth route và đã đăng nhập, check onboarding
        if (isAuthRoute && isAuthenticated) {
          final hasCompleted = await OnboardingPage.hasCompletedOnboarding();
          if (!hasCompleted) {
            return onboarding;
          }
          return home;
        }

        // Nếu đã đăng nhập và không phải onboarding route, check onboarding
        if (isAuthenticated && !isOnboardingRoute && !isAuthRoute) {
          final hasCompleted = await OnboardingPage.hasCompletedOnboarding();
          if (!hasCompleted) {
            return onboarding;
          }
        }

        // Nếu không phải auth route và chưa đăng nhập, redirect đến auth
        // (AuthGuard sẽ handle authentication check for protected routes)
        if (!isAuthRoute && !isOnboardingRoute && !isAuthenticated) {
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
      // Onboarding route - Requires authentication
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const AuthGuard(
          child: OnboardingPage(),
        ),
      ),
      // Protected routes - Require authentication (including home)
      ShellRoute(
        builder: (context, state, child) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          final topSafeArea = MediaQuery.of(context).padding.top;
          // Height = safe area + logo (56) + padding (8*2) = safe area + 72
          final appBarHeight = topSafeArea + 72.0;
          
          return ConnectivitySnackbar(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.background,
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
            routes: [
              GoRoute(
                path: ':invoiceId',
                name: 'invoiceDetail',
                builder: (context, state) {
                  final invoiceId = state.pathParameters['invoiceId']!;
                  return AuthGuard(
                    child: InvoiceDetailPage(billId: invoiceId),
                  );
                },
              ),
            ],
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
        ],
      ),
      // Full screen pages (not in ShellRoute)
      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const AuthGuard(
          child: NotificationsPage(),
        ),
          ),
          GoRoute(
            path: notificationSettings,
            name: 'notificationSettings',
            builder: (context, state) => const AuthGuard(
              child: NotificationSettingsPage(),
            ),
          ),
          GoRoute(
            path: languageSettings,
            name: 'languageSettings',
            builder: (context, state) => const AuthGuard(
              child: LanguageSettingsPage(),
            ),
          ),
      GoRoute(
        path: appInfo,
        name: 'appInfo',
        builder: (context, state) => const AuthGuard(
          child: AppInfoPage(),
        ),
      ),
      GoRoute(
        path: personalInfo,
        name: 'personalInfo',
        builder: (context, state) => const AuthGuard(
          child: PersonalInfoPage(),
        ),
      ),
      GoRoute(
        path: accountSettings,
        name: 'accountSettings',
        builder: (context, state) => const AuthGuard(
          child: AccountSettingsPage(),
        ),
      ),
      GoRoute(
        path: feedback,
        name: 'feedback',
        builder: (context, state) => const AuthGuard(
          child: FeedbackPage(),
        ),
      ),
    ];
  }
}
