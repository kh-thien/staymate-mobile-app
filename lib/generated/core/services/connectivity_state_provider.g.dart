// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../core/services/connectivity_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConnectivityState)
const connectivityStateProvider = ConnectivityStateProvider._();

final class ConnectivityStateProvider
    extends $NotifierProvider<ConnectivityState, ConnectivityStatus> {
  const ConnectivityStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStateHash();

  @$internal
  @override
  ConnectivityState create() => ConnectivityState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityStatus>(value),
    );
  }
}

String _$connectivityStateHash() => r'5fd97e907abb1bd045a4e04c5dd9ad18a4fb61dd';

abstract class _$ConnectivityState extends $Notifier<ConnectivityStatus> {
  ConnectivityStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ConnectivityStatus, ConnectivityStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConnectivityStatus, ConnectivityStatus>,
              ConnectivityStatus,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
