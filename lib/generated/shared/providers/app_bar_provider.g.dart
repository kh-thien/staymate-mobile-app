// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../shared/providers/app_bar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppBarNotifier)
const appBarProvider = AppBarNotifierProvider._();

final class AppBarNotifierProvider
    extends $NotifierProvider<AppBarNotifier, AppBarState> {
  const AppBarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBarNotifierHash();

  @$internal
  @override
  AppBarNotifier create() => AppBarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppBarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppBarState>(value),
    );
  }
}

String _$appBarNotifierHash() => r'd658b29afa023c8221070b14253d160f2b7157ad';

abstract class _$AppBarNotifier extends $Notifier<AppBarState> {
  AppBarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppBarState, AppBarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppBarState, AppBarState>,
              AppBarState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
