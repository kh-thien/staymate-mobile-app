// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../core/services/locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for current locale
/// keepAlive: true để đảm bảo provider không bị dispose khi không có watchers

@ProviderFor(AppLocale)
const appLocaleProvider = AppLocaleProvider._();

/// Provider for current locale
/// keepAlive: true để đảm bảo provider không bị dispose khi không có watchers
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale> {
  /// Provider for current locale
  /// keepAlive: true để đảm bảo provider không bị dispose khi không có watchers
  const AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'a37d506b24b5e86200b7ff00af73f3af1cae0de3';

/// Provider for current locale
/// keepAlive: true để đảm bảo provider không bị dispose khi không có watchers

abstract class _$AppLocale extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
