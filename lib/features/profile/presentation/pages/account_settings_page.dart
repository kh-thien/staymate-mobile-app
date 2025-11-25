import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../features/auth/presentation/utils/auth_error_handler.dart';
import '../widgets/account_overview_card.dart';
import '../widgets/password_section.dart';
import '../widgets/social_login_notice.dart';
import '../widgets/delete_account_section.dart';
import '../widgets/delete_account_sheet.dart';
import '../widgets/delete_account_success_dialog.dart';
import '../widgets/blocking_overlay.dart';

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
    final isDeleteLoading = useState(false);
    final deleteProgress = useState<double>(0.0);

    final Map<String, dynamic> appMetadata = Map<String, dynamic>.from(
      user?.appMetadata ?? {},
    );
    final provider = (appMetadata['provider'] as String?) ?? 'email';
    final providerLabel = _formatProviderName(provider, languageCode);
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
          AppLocalizationsHelper.translate('passwordsDoNotMatch', languageCode),
          Colors.red,
        );
        return;
      }

      if (next.length < 8) {
        _showSnackBar(
          context,
          AppLocalizationsHelper.translate('passwordTooShort', languageCode),
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
          AppLocalizationsHelper.translate('passwordUpdated', languageCode),
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

    Future<void> onDeleteAccount() async {
      final result = await showDeleteAccountSheet(
        context: context,
        isDark: isDark,
        languageCode: languageCode,
      );

      if (result == null || !result.confirmed) {
        return;
      }

      if (context.mounted) {
        isDeleteLoading.value = true;
        deleteProgress.value = 0.0;
      }

      // Simulate progress
      Timer? progressTimer;
      try {
        // Bắt đầu simulate progress
        int progressStep = 0;
        progressTimer = Timer.periodic(const Duration(milliseconds: 150), (
          timer,
        ) {
          if (!context.mounted || !isDeleteLoading.value) {
            timer.cancel();
            return;
          }
          progressStep++;
          // Tăng progress từ 0 đến 0.85 trong khoảng 3 giây
          if (progressStep <= 20) {
            deleteProgress.value = (progressStep * 0.85 / 20).clamp(0.0, 0.85);
          }
        });

        // Đợi một chút để progress hiển thị
        await Future.delayed(const Duration(milliseconds: 300));

        await authService.deleteAccount(
          reason: result.reason,
          signOutAfter: false,
        );

        // Đạt 100% khi thành công
        if (context.mounted) {
          progressTimer.cancel();
          deleteProgress.value = 1.0;
          await Future.delayed(const Duration(milliseconds: 500));
        }

        if (!context.mounted) {
          return;
        }

        // Tắt loading trước khi hiển thị dialog
        if (isDeleteLoading.value) {
          isDeleteLoading.value = false;
        }

        await showDeleteAccountSuccessDialog(
          context: context,
          languageCode: languageCode,
        );

        await authService.signOut(skipFCMTokenDeletion: true);

        if (!context.mounted) {
          return;
        }
        context.go('/auth');
      } on AuthException catch (e) {
        final message = AuthErrorHandler.getErrorMessage(e, languageCode);
        _showSnackBar(context, message, Colors.red);
      } catch (_) {
        _showSnackBar(
          context,
          AppLocalizationsHelper.translate('deleteAccountFailed', languageCode),
          Colors.red,
        );
      } finally {
        if (progressTimer != null && progressTimer.isActive) {
          progressTimer.cancel();
        }
        if (context.mounted) {
          isDeleteLoading.value = false;
          deleteProgress.value = 0.0;
        }
      }
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: isDark
                ? AppColors.surfaceDarkElevated
                : Colors.white,
            foregroundColor: isDark ? AppColors.textPrimaryDark : Colors.black,
            titleTextStyle: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : Colors.black,
            ),
            title: Text(
              AppLocalizationsHelper.translate('account', languageCode),
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
                    SocialLoginNotice(languageCode: languageCode),
                  const SizedBox(height: 24),
                  DeleteAccountSection(
                    languageCode: languageCode,
                    isDark: isDark,
                    isLoading: isDeleteLoading.value,
                    onDeleteTap: onDeleteAccount,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isDeleteLoading.value)
          BlockingOverlay(
            isDark: isDark,
            progress: deleteProgress.value,
            message: AppLocalizationsHelper.translate(
              'deleteAccountDeletingData',
              languageCode,
            ),
          ),
      ],
    );
  }

  /// Format provider name để hiển thị đẹp hơn
  String _formatProviderName(String provider, String languageCode) {
    switch (provider.toLowerCase()) {
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      case 'email':
        return AppLocalizationsHelper.translate('email', languageCode);
      default:
        return provider.toUpperCase();
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
