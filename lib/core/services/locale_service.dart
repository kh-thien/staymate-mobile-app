import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _localeKey = 'app_locale';
  static const Locale englishLocale = Locale('en', 'US');
  static const Locale vietnameseLocale = Locale('vi', 'VN');
  static const Locale defaultLocale = englishLocale;

  /// Get saved locale from SharedPreferences
  static Future<Locale> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);

      if (localeCode == null) {
        return defaultLocale;
      }

      // Parse locale code (e.g., "vi_VN" or "en_US")
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        return Locale(parts[0], parts[1]);
      } else if (parts.length == 1) {
        return Locale(parts[0]);
      }

      return defaultLocale;
    } catch (e) {
      return defaultLocale;
    }
  }

  /// Save locale to SharedPreferences
  static Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save locale code with format: languageCode_countryCode
      // If countryCode is null, only save languageCode
      final localeCode =
          locale.countryCode != null && locale.countryCode!.isNotEmpty
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await prefs.setString(_localeKey, localeCode);
      // Debug: Print saved locale
      debugPrint('🌐 Saved locale: $localeCode');
    } catch (e) {
      debugPrint('❌ Error saving locale: $e');
      // Ignore error
    }
  }

  /// Get supported locales
  static List<Locale> getSupportedLocales() {
    return [englishLocale, vietnameseLocale];
  }

  /// Check if locale is Vietnamese
  static bool isVietnamese(Locale locale) {
    return locale.languageCode == vietnameseLocale.languageCode;
  }

  /// Check if locale is English
  static bool isEnglish(Locale locale) {
    return locale.languageCode == englishLocale.languageCode;
  }
}
