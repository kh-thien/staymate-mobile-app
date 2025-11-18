// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../core/services/auth_subscription_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthSubscriptionManager)
const authSubscriptionManagerProvider = AuthSubscriptionManagerProvider._();

final class AuthSubscriptionManagerProvider
    extends $NotifierProvider<AuthSubscriptionManager, void> {
  const AuthSubscriptionManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSubscriptionManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSubscriptionManagerHash();

  @$internal
  @override
  AuthSubscriptionManager create() => AuthSubscriptionManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$authSubscriptionManagerHash() =>
    r'475f5b584663f6577f523ac4536bc14113b2bc17';

abstract class _$AuthSubscriptionManager extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
