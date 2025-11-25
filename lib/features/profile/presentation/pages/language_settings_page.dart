import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/app_styles.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLocale = ref.watch(appLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);
    final languageCode = currentLocale.languageCode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDarkElevated : Colors.white,
        foregroundColor: isDark
            ? AppColors.textPrimaryDark
            : const Color(0xFF2D3748),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF2D3748),
          ),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          AppLocalizationsHelper.translate('language', languageCode),
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? AppColors.dividerDark : Colors.grey[200]!,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Vietnamese option
          _buildLanguageOption(
            context: context,
            locale: LocaleService.vietnameseLocale,
            title: 'Tiếng Việt',
            subtitle: 'Vietnamese',
            isSelected: LocaleService.isVietnamese(currentLocale),
            languageCode: languageCode,
            onTap: () {
              localeNotifier.setLocale(LocaleService.vietnameseLocale);
            },
          ),

          // English option
          _buildLanguageOption(
            context: context,
            locale: LocaleService.englishLocale,
            title: 'English',
            subtitle: 'Tiếng Anh',
            isSelected: LocaleService.isEnglish(currentLocale),
            languageCode: languageCode,
            onTap: () {
              localeNotifier.setLocale(LocaleService.englishLocale);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required Locale locale,
    required String title,
    required String subtitle,
    required bool isSelected,
    required String languageCode,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDark ? AppColors.borderDark : Colors.grey[300]!),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : Colors.grey[600]!,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
