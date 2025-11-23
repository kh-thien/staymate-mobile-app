import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/logo_app.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({super.key});

  static const String _onboardingKey = 'has_completed_onboarding';

  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final pageController = usePageController();
    final currentPage = useState(0);

    final onboardingPages = [
      _OnboardingSlide(
        icon: Icons.home_rounded,
        title: AppLocalizationsHelper.translate(
          'onboardingWelcomeTitle',
          languageCode,
        ),
        description: AppLocalizationsHelper.translate(
          'onboardingWelcomeDescription',
          languageCode,
        ),
        languageCode: languageCode,
      ),
      _OnboardingSlide(
        icon: Icons.description_rounded,
        title: AppLocalizationsHelper.translate(
          'onboardingContractsTitle',
          languageCode,
        ),
        description: AppLocalizationsHelper.translate(
          'onboardingContractsDescription',
          languageCode,
        ),
        languageCode: languageCode,
      ),
      _OnboardingSlide(
        icon: Icons.receipt_long_rounded,
        title: AppLocalizationsHelper.translate(
          'onboardingInvoicesTitle',
          languageCode,
        ),
        description: AppLocalizationsHelper.translate(
          'onboardingInvoicesDescription',
          languageCode,
        ),
        languageCode: languageCode,
      ),
      _OnboardingSlide(
        icon: Icons.report_problem_rounded,
        title: AppLocalizationsHelper.translate(
          'onboardingReportsTitle',
          languageCode,
        ),
        description: AppLocalizationsHelper.translate(
          'onboardingReportsDescription',
          languageCode,
        ),
        languageCode: languageCode,
      ),
      _OnboardingSlide(
        icon: Icons.chat_bubble_outline_rounded,
        title: AppLocalizationsHelper.translate(
          'onboardingChatTitle',
          languageCode,
        ),
        description: AppLocalizationsHelper.translate(
          'onboardingChatDescription',
          languageCode,
        ),
        languageCode: languageCode,
      ),
      _OnboardingSlide(
        icon: Icons.qr_code_scanner_rounded,
        title: AppLocalizationsHelper.translate(
          'onboardingConnectTitle',
          languageCode,
        ),
        description: AppLocalizationsHelper.translate(
          'onboardingConnectDescription',
          languageCode,
        ),
        isLast: true,
        languageCode: languageCode,
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () async {
                    await OnboardingPage.completeOnboarding();
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                  child: Text(
                    AppLocalizationsHelper.translate(
                      'skip',
                      languageCode,
                    ),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  currentPage.value = index;
                },
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return onboardingPages[index];
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingPages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage.value == index
                          ? theme.colorScheme.primary
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : Colors.grey[300]!),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  if (currentPage.value > 0)
                    TextButton(
                      onPressed: () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        AppLocalizationsHelper.translate(
                          'back',
                          languageCode,
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: () async {
                      if (currentPage.value < onboardingPages.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await OnboardingPage.completeOnboarding();
                        if (context.mounted) {
                          context.go('/');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      currentPage.value < onboardingPages.length - 1
                          ? AppLocalizationsHelper.translate(
                              'next',
                              languageCode,
                            )
                          : AppLocalizationsHelper.translate(
                              'getStarted',
                              languageCode,
                            ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;
  final String languageCode;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo (only on first slide)
          if (!isLast && icon == Icons.home_rounded) ...[
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                LogoApp.logoIcon,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
          ] else ...[
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 50,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),
          ],

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

