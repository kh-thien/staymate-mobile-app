import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'locale_service.dart';

part '../../generated/core/services/locale_provider.g.dart';

/// Provider for current locale
/// keepAlive: true để đảm bảo provider không bị dispose khi không có watchers
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    // Initialize locale by loading from SharedPreferences
    // This will start with defaultLocale, then update when async load completes
    _initializeLocale();
    return LocaleService.defaultLocale;
  }

  /// Initialize locale by loading from SharedPreferences
  void _initializeLocale() {
    // Load saved locale asynchronously and update state
    LocaleService.getSavedLocale().then((savedLocale) {
      state = savedLocale;
    }).catchError((e) {
      // Use default locale on error (already set in build())
    });
  }

  /// Change locale
  Future<void> setLocale(Locale locale) async {
    debugPrint('🌐 Changing locale to: ${locale.languageCode}_${locale.countryCode}');
    await LocaleService.saveLocale(locale);
    state = locale;
    debugPrint('✅ Locale changed to: ${state.languageCode}_${state.countryCode}');
  }

  /// Toggle between Vietnamese and English
  Future<void> toggleLocale() async {
    final newLocale = LocaleService.isVietnamese(state)
        ? LocaleService.englishLocale
        : LocaleService.defaultLocale;
    await setLocale(newLocale);
  }

  /// Check if current locale is Vietnamese
  bool get isVietnamese => LocaleService.isVietnamese(state);

  /// Check if current locale is English
  bool get isEnglish => LocaleService.isEnglish(state);
}
