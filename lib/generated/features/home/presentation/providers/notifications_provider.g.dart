// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/home/presentation/providers/notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationRemoteDatasource)
const notificationRemoteDatasourceProvider =
    NotificationRemoteDatasourceProvider._();

final class NotificationRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          NotificationRemoteDatasource,
          NotificationRemoteDatasource,
          NotificationRemoteDatasource
        >
    with $Provider<NotificationRemoteDatasource> {
  const NotificationRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<NotificationRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRemoteDatasource create(Ref ref) {
    return notificationRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRemoteDatasource>(value),
    );
  }
}

String _$notificationRemoteDatasourceHash() =>
    r'80effcf8a7f0d11ba78650d414ef22b9cfb4debb';

@ProviderFor(recentNotifications)
const recentNotificationsProvider = RecentNotificationsProvider._();

final class RecentNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationModel>>,
          List<NotificationModel>,
          FutureOr<List<NotificationModel>>
        >
    with
        $FutureModifier<List<NotificationModel>>,
        $FutureProvider<List<NotificationModel>> {
  const RecentNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentNotificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<NotificationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NotificationModel>> create(Ref ref) {
    return recentNotifications(ref);
  }
}

String _$recentNotificationsHash() =>
    r'ec9fe73a4283c3b6812aefa9fecdbad86c311ee2';

@ProviderFor(allNotifications)
const allNotificationsProvider = AllNotificationsProvider._();

final class AllNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationModel>>,
          List<NotificationModel>,
          FutureOr<List<NotificationModel>>
        >
    with
        $FutureModifier<List<NotificationModel>>,
        $FutureProvider<List<NotificationModel>> {
  const AllNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allNotificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<NotificationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NotificationModel>> create(Ref ref) {
    return allNotifications(ref);
  }
}

String _$allNotificationsHash() => r'ddb99a421da56f651800c01ed8319b221781854c';

/// Stream provider for realtime notifications updates

@ProviderFor(allNotificationsStream)
const allNotificationsStreamProvider = AllNotificationsStreamProvider._();

/// Stream provider for realtime notifications updates

final class AllNotificationsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationModel>>,
          List<NotificationModel>,
          Stream<List<NotificationModel>>
        >
    with
        $FutureModifier<List<NotificationModel>>,
        $StreamProvider<List<NotificationModel>> {
  /// Stream provider for realtime notifications updates
  const AllNotificationsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allNotificationsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allNotificationsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<NotificationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationModel>> create(Ref ref) {
    return allNotificationsStream(ref);
  }
}

String _$allNotificationsStreamHash() =>
    r'18cd4fab1c3ca9ecd050c324e6ad8ab7edac08cf';

@ProviderFor(unreadNotificationsCount)
const unreadNotificationsCountProvider = UnreadNotificationsCountProvider._();

final class UnreadNotificationsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  const UnreadNotificationsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationsCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return unreadNotificationsCount(ref);
  }
}

String _$unreadNotificationsCountHash() =>
    r'e919d4b26178f8665b5c8824a5fede09c1502009';

@ProviderFor(recentNotificationsStream)
const recentNotificationsStreamProvider = RecentNotificationsStreamProvider._();

final class RecentNotificationsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationModel>>,
          List<NotificationModel>,
          Stream<List<NotificationModel>>
        >
    with
        $FutureModifier<List<NotificationModel>>,
        $StreamProvider<List<NotificationModel>> {
  const RecentNotificationsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentNotificationsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentNotificationsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<NotificationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationModel>> create(Ref ref) {
    return recentNotificationsStream(ref);
  }
}

String _$recentNotificationsStreamHash() =>
    r'62d9752f112583c7456a1e9fa6cdd5e9aff38396';

@ProviderFor(markNotificationAsRead)
const markNotificationAsReadProvider = MarkNotificationAsReadFamily._();

final class MarkNotificationAsReadProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const MarkNotificationAsReadProvider._({
    required MarkNotificationAsReadFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'markNotificationAsReadProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$markNotificationAsReadHash();

  @override
  String toString() {
    return r'markNotificationAsReadProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as String;
    return markNotificationAsRead(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MarkNotificationAsReadProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$markNotificationAsReadHash() =>
    r'f67759f494bcd1de4b1bbf114a08e31d6fec020a';

final class MarkNotificationAsReadFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const MarkNotificationAsReadFamily._()
    : super(
        retry: null,
        name: r'markNotificationAsReadProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarkNotificationAsReadProvider call(String notificationId) =>
      MarkNotificationAsReadProvider._(argument: notificationId, from: this);

  @override
  String toString() => r'markNotificationAsReadProvider';
}
