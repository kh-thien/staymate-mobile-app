import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../features/auth/presentation/utils/auth_error_handler.dart';
import '../widgets/account_overview_card.dart';
import '../widgets/password_section.dart';
import '../widgets/social_login_notice.dart';

class AccountSettingsPage extends HookConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final languageCode = ref.watch(appLocaleProvider).languageCode;
    final user = Supabase.instance.client.auth.currentUser;
    final authService = AuthService();

    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isLoading = useState(false);
    final isExpanded = useState(true);

    final Map<String, dynamic> appMetadata =
        Map<String, dynamic>.from(user?.appMetadata ?? {});
    final providerLabel =
        (appMetadata['provider'] as String?)?.toUpperCase() ??
            AppLocalizationsHelper.translate('email', languageCode).toUpperCase();
    final dynamic providersRaw = appMetadata['providers'];
    final isPasswordProviderLogin =
        (appMetadata['provider'] as String?) == 'email' ||
            (providersRaw is List && providersRaw.contains('email'));

    Future<void> onChangePassword() async {
      final current = currentPasswordController.text.trim();
      final next = newPasswordController.text.trim();
      final confirm = confirmPasswordController.text.trim();

      if (next != confirm) {
        _showSnackBar(
          context,
          AppLocalizationsHelper.translate(
            'passwordsDoNotMatch',
            languageCode,
          ),
          Colors.red,
        );
        return;
      }

      if (next.length < 8) {
        _showSnackBar(
          context,
          AppLocalizationsHelper.translate(
            'passwordTooShort',
            languageCode,
          ),
          Colors.red,
        );
        return;
      }

      isLoading.value = true;
      try {
        await authService.changePassword(
          currentPassword: current,
          newPassword: next,
          languageCode: languageCode,
        );
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        _showSnackBar(
          context,
          AppLocalizationsHelper.translate(
            'passwordUpdated',
            languageCode,
          ),
          Colors.green,
        );
      } catch (e) {
        final message = e is AuthException
            ? AuthErrorHandler.getErrorMessage(e, languageCode)
            : AppLocalizationsHelper.translate(
                'authUnknownError',
                languageCode,
              );
        _showSnackBar(context, message, Colors.red);
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.surfaceDarkElevated : Colors.white,
        foregroundColor:
            isDark ? AppColors.textPrimaryDark : Colors.black,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : Colors.black,
        ),
        title: Text(
          AppLocalizationsHelper.translate(
            'account',
            languageCode,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: isDark ? AppColors.surfaceDark : AppColors.background,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountOverviewCard(
                email: user?.email ?? '-',
                provider: providerLabel,
                userId: user?.id ?? '-',
                languageCode: languageCode,
              ),
              const SizedBox(height: 20),
              if (isPasswordProviderLogin)
                PasswordSection(
                  languageCode: languageCode,
                  isDark: isDark,
                  isExpanded: isExpanded.value,
                  isLoading: isLoading.value,
                  currentPasswordController: currentPasswordController,
                  newPasswordController: newPasswordController,
                  confirmPasswordController: confirmPasswordController,
                  onToggle: () => isExpanded.value = !isExpanded.value,
                  onSubmit: onChangePassword,
                )
              else
                SocialLoginNotice(
                  languageCode: languageCode,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}

