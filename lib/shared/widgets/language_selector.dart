import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/services/locale_provider.dart';
import '../../core/services/locale_service.dart';
import '../../core/localization/app_localizations_helper.dart';

/// Widget để chọn ngôn ngữ - Hiển thị dropdown menu
class LanguageSelector extends ConsumerWidget {
  final bool isCompact;
  final Color? iconColor;
  final double? iconSize;

  const LanguageSelector({
    super.key,
    this.isCompact = false,
    this.iconColor,
    this.iconSize,
  });

  /// Get flag emoji for locale
  static String getFlagEmoji(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return '🇻🇳';
      case 'en':
        return '🇺🇸';
      default:
        return '🌐';
    }
  }

  /// Get language code display (VN, EN, etc.)
  static String getLanguageCode(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return 'VN';
      case 'en':
        return 'EN';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);
    final languageCode = locale.languageCode;

    // Nếu là compact mode, hiển thị icon + flag + code
    if (isCompact) {
      final flagEmoji = getFlagEmoji(locale);
      final langCode = getLanguageCode(locale);
      
      return PopupMenuButton<Locale>(
        tooltip: AppLocalizationsHelper.translate('language', languageCode),
        onSelected: (Locale selectedLocale) async {
          await localeNotifier.setLocale(selectedLocale);
          // Debug: Print selected locale
          debugPrint('🌐 User selected locale: ${selectedLocale.languageCode}_${selectedLocale.countryCode}');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                color: iconColor ?? Theme.of(context).iconTheme.color,
                size: iconSize ?? 20,
              ),
              const SizedBox(width: 6),
              Text(
                flagEmoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                langCode,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: iconColor ?? Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<Locale>(
            value: LocaleService.defaultLocale,
            child: Row(
              children: [
                Text(
                  getFlagEmoji(LocaleService.defaultLocale),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizationsHelper.translate('vietnamese', languageCode),
                  style: TextStyle(
                    fontWeight: LocaleService.isVietnamese(locale)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (LocaleService.isVietnamese(locale)) ...[
                  const Spacer(),
                  Icon(
                    Icons.check,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
          PopupMenuItem<Locale>(
            value: LocaleService.englishLocale,
            child: Row(
              children: [
                Text(
                  getFlagEmoji(LocaleService.englishLocale),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizationsHelper.translate('english', languageCode),
                  style: TextStyle(
                    fontWeight: LocaleService.isEnglish(locale)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (LocaleService.isEnglish(locale)) ...[
                  const Spacer(),
                  Icon(
                    Icons.check,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    // Full mode - Hiển thị button với flag + code
    final flagEmoji = getFlagEmoji(locale);
    final langCode = getLanguageCode(locale);
    
    return PopupMenuButton<Locale>(
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              flagEmoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 4),
            Text(
              langCode,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
      onSelected: (Locale selectedLocale) async {
        await localeNotifier.setLocale(selectedLocale);
        // Debug: Print selected locale
        debugPrint('🌐 User selected locale: ${selectedLocale.languageCode}_${selectedLocale.countryCode}');
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: LocaleService.defaultLocale,
          child: Row(
            children: [
              Text(
                getFlagEmoji(LocaleService.defaultLocale),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizationsHelper.translate('vietnamese', languageCode),
                style: TextStyle(
                  fontWeight: LocaleService.isVietnamese(locale)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (LocaleService.isVietnamese(locale)) ...[
                const Spacer(),
                Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: LocaleService.englishLocale,
          child: Row(
            children: [
              Text(
                getFlagEmoji(LocaleService.englishLocale),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizationsHelper.translate('english', languageCode),
                style: TextStyle(
                  fontWeight: LocaleService.isEnglish(locale)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (LocaleService.isEnglish(locale)) ...[
                const Spacer(),
                Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
