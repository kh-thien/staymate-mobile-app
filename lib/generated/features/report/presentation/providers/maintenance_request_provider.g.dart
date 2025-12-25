// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/report/presentation/providers/maintenance_request_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Supabase client provider

@ProviderFor(supabaseClient)
const supabaseClientProvider = SupabaseClientProvider._();

/// Supabase client provider

final class SupabaseClientProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  /// Supabase client provider
  const SupabaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseClientHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseClientHash() => r'834a58d6ae4b94e36f4e04a10d8a7684b929310e';

/// Datasource provider

@ProviderFor(maintenanceRequestDatasource)
const maintenanceRequestDatasourceProvider =
    MaintenanceRequestDatasourceProvider._();

/// Datasource provider

final class MaintenanceRequestDatasourceProvider
    extends
        $FunctionalProvider<
          MaintenanceRequestRemoteDatasource,
          MaintenanceRequestRemoteDatasource,
          MaintenanceRequestRemoteDatasource
        >
    with $Provider<MaintenanceRequestRemoteDatasource> {
  /// Datasource provider
  const MaintenanceRequestDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRequestDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRequestDatasourceHash();

  @$internal
  @override
  $ProviderElement<MaintenanceRequestRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MaintenanceRequestRemoteDatasource create(Ref ref) {
    return maintenanceRequestDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaintenanceRequestRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaintenanceRequestRemoteDatasource>(
        value,
      ),
    );
  }
}

String _$maintenanceRequestDatasourceHash() =>
    r'a818e2cc035f1c3462150ab6272aeea23bf125d1';

/// Repository provider

@ProviderFor(maintenanceRequestRepository)
const maintenanceRequestRepositoryProvider =
    MaintenanceRequestRepositoryProvider._();

/// Repository provider

final class MaintenanceRequestRepositoryProvider
    extends
        $FunctionalProvider<
          MaintenanceRequestRepository,
          MaintenanceRequestRepository,
          MaintenanceRequestRepository
        >
    with $Provider<MaintenanceRequestRepository> {
  /// Repository provider
  const MaintenanceRequestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRequestRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRequestRepositoryHash();

  @$internal
  @override
  $ProviderElement<MaintenanceRequestRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MaintenanceRequestRepository create(Ref ref) {
    return maintenanceRequestRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaintenanceRequestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaintenanceRequestRepository>(value),
    );
  }
}

String _$maintenanceRequestRepositoryHash() =>
    r'5aaa8177d51e2b2c8d5dc29f82dc6cad611165dc';

/// Get active contracts

@ProviderFor(activeContracts)
const activeContractsProvider = ActiveContractsProvider._();

/// Get active contracts

final class ActiveContractsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Contract>>,
          List<Contract>,
          FutureOr<List<Contract>>
        >
    with $FutureModifier<List<Contract>>, $FutureProvider<List<Contract>> {
  /// Get active contracts
  const ActiveContractsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeContractsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeContractsHash();

  @$internal
  @override
  $FutureProviderElement<List<Contract>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Contract>> create(Ref ref) {
    return activeContracts(ref);
  }
}

String _$activeContractsHash() => r'9bf95393151af43b8fba646b45d992fd57b2556d';

/// Get maintenance requests list

@ProviderFor(maintenanceRequestsList)
const maintenanceRequestsListProvider = MaintenanceRequestsListProvider._();

/// Get maintenance requests list

final class MaintenanceRequestsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MaintenanceRequest>>,
          List<MaintenanceRequest>,
          FutureOr<List<MaintenanceRequest>>
        >
    with
        $FutureModifier<List<MaintenanceRequest>>,
        $FutureProvider<List<MaintenanceRequest>> {
  /// Get maintenance requests list
  const MaintenanceRequestsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRequestsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRequestsListHash();

  @$internal
  @override
  $FutureProviderElement<List<MaintenanceRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MaintenanceRequest>> create(Ref ref) {
    return maintenanceRequestsList(ref);
  }
}

String _$maintenanceRequestsListHash() =>
    r'82d0fd77c2e7df38b152e882a9e5cd2963da3c2e';

/// Stream maintenance requests for realtime

@ProviderFor(maintenanceRequestsStream)
const maintenanceRequestsStreamProvider = MaintenanceRequestsStreamProvider._();

/// Stream maintenance requests for realtime

final class MaintenanceRequestsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MaintenanceRequest>>,
          List<MaintenanceRequest>,
          Stream<List<MaintenanceRequest>>
        >
    with
        $FutureModifier<List<MaintenanceRequest>>,
        $StreamProvider<List<MaintenanceRequest>> {
  /// Stream maintenance requests for realtime
  const MaintenanceRequestsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRequestsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRequestsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<MaintenanceRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MaintenanceRequest>> create(Ref ref) {
    return maintenanceRequestsStream(ref);
  }
}

String _$maintenanceRequestsStreamHash() =>
    r'08892a2d27caa5a9fbe5a81200d92efca0c7b873';

/// Get maintenance request detail

@ProviderFor(maintenanceRequestDetail)
const maintenanceRequestDetailProvider = MaintenanceRequestDetailFamily._();

/// Get maintenance request detail

final class MaintenanceRequestDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<MaintenanceRequest>,
          MaintenanceRequest,
          FutureOr<MaintenanceRequest>
        >
    with
        $FutureModifier<MaintenanceRequest>,
        $FutureProvider<MaintenanceRequest> {
  /// Get maintenance request detail
  const MaintenanceRequestDetailProvider._({
    required MaintenanceRequestDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'maintenanceRequestDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRequestDetailHash();

  @override
  String toString() {
    return r'maintenanceRequestDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MaintenanceRequest> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MaintenanceRequest> create(Ref ref) {
    final argument = this.argument as String;
    return maintenanceRequestDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MaintenanceRequestDetailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$maintenanceRequestDetailHash() =>
    r'573db73c6c4aebc9c22b474a4abd59c47499482a';

/// Get maintenance request detail

final class MaintenanceRequestDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MaintenanceRequest>, String> {
  const MaintenanceRequestDetailFamily._()
    : super(
        retry: null,
        name: r'maintenanceRequestDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get maintenance request detail

  MaintenanceRequestDetailProvider call(String id) =>
      MaintenanceRequestDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'maintenanceRequestDetailProvider';
}

/// Create maintenance request

@ProviderFor(MaintenanceRequestCreator)
const maintenanceRequestCreatorProvider = MaintenanceRequestCreatorProvider._();

/// Create maintenance request
final class MaintenanceRequestCreatorProvider
    extends
        $AsyncNotifierProvider<MaintenanceRequestCreator, MaintenanceRequest?> {
  /// Create maintenance request
  const MaintenanceRequestCreatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRequestCreatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRequestCreatorHash();

  @$internal
  @override
  MaintenanceRequestCreator create() => MaintenanceRequestCreator();
}

String _$maintenanceRequestCreatorHash() =>
    r'e23931eea2563dcc0fecc61f6b405e349b178c34';

/// Create maintenance request

abstract class _$MaintenanceRequestCreator
    extends $AsyncNotifier<MaintenanceRequest?> {
  FutureOr<MaintenanceRequest?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<MaintenanceRequest?>, MaintenanceRequest?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MaintenanceRequest?>, MaintenanceRequest?>,
              AsyncValue<MaintenanceRequest?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Cancel maintenance request - simple future provider approach

@ProviderFor(cancelMaintenanceRequest)
const cancelMaintenanceRequestProvider = CancelMaintenanceRequestFamily._();

/// Cancel maintenance request - simple future provider approach

final class CancelMaintenanceRequestProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Cancel maintenance request - simple future provider approach
  const CancelMaintenanceRequestProvider._({
    required CancelMaintenanceRequestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cancelMaintenanceRequestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cancelMaintenanceRequestHash();

  @override
  String toString() {
    return r'cancelMaintenanceRequestProvider'
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
    return cancelMaintenanceRequest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CancelMaintenanceRequestProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cancelMaintenanceRequestHash() =>
    r'0d3b50d0e8985cb87a2413a7d97b24cddc53ed08';

/// Cancel maintenance request - simple future provider approach

final class CancelMaintenanceRequestFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const CancelMaintenanceRequestFamily._()
    : super(
        retry: null,
        name: r'cancelMaintenanceRequestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Cancel maintenance request - simple future provider approach

  CancelMaintenanceRequestProvider call(String id) =>
      CancelMaintenanceRequestProvider._(argument: id, from: this);

  @override
  String toString() => r'cancelMaintenanceRequestProvider';
}

/// Delete maintenance request - simple future provider approach

@ProviderFor(deleteMaintenanceRequest)
const deleteMaintenanceRequestProvider = DeleteMaintenanceRequestFamily._();

/// Delete maintenance request - simple future provider approach

final class DeleteMaintenanceRequestProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Delete maintenance request - simple future provider approach
  const DeleteMaintenanceRequestProvider._({
    required DeleteMaintenanceRequestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'deleteMaintenanceRequestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteMaintenanceRequestHash();

  @override
  String toString() {
    return r'deleteMaintenanceRequestProvider'
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
    return deleteMaintenanceRequest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteMaintenanceRequestProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteMaintenanceRequestHash() =>
    r'e01eb3b20b38520b1cde75c251a4043c3dafeacb';

/// Delete maintenance request - simple future provider approach

final class DeleteMaintenanceRequestFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const DeleteMaintenanceRequestFamily._()
    : super(
        retry: null,
        name: r'deleteMaintenanceRequestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Delete maintenance request - simple future provider approach

  DeleteMaintenanceRequestProvider call(String id) =>
      DeleteMaintenanceRequestProvider._(argument: id, from: this);

  @override
  String toString() => r'deleteMaintenanceRequestProvider';
}

/// Get maintenance records (READ-ONLY for tenant)
/// Fetches maintenance work for properties the tenant has active contracts with
/// Automatically filters out CANCELLED status

@ProviderFor(maintenanceRecords)
const maintenanceRecordsProvider = MaintenanceRecordsProvider._();

/// Get maintenance records (READ-ONLY for tenant)
/// Fetches maintenance work for properties the tenant has active contracts with
/// Automatically filters out CANCELLED status

final class MaintenanceRecordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Maintenance>>,
          List<Maintenance>,
          FutureOr<List<Maintenance>>
        >
    with
        $FutureModifier<List<Maintenance>>,
        $FutureProvider<List<Maintenance>> {
  /// Get maintenance records (READ-ONLY for tenant)
  /// Fetches maintenance work for properties the tenant has active contracts with
  /// Automatically filters out CANCELLED status
  const MaintenanceRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRecordsHash();

  @$internal
  @override
  $FutureProviderElement<List<Maintenance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Maintenance>> create(Ref ref) {
    return maintenanceRecords(ref);
  }
}

String _$maintenanceRecordsHash() =>
    r'c85cc9046e1d5f1e9781ad989404686da93e803d';

/// Stream maintenance records for realtime updates

@ProviderFor(maintenanceRecordsStream)
const maintenanceRecordsStreamProvider = MaintenanceRecordsStreamProvider._();

/// Stream maintenance records for realtime updates

final class MaintenanceRecordsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Maintenance>>,
          List<Maintenance>,
          Stream<List<Maintenance>>
        >
    with
        $FutureModifier<List<Maintenance>>,
        $StreamProvider<List<Maintenance>> {
  /// Stream maintenance records for realtime updates
  const MaintenanceRecordsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceRecordsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceRecordsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Maintenance>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Maintenance>> create(Ref ref) {
    return maintenanceRecordsStream(ref);
  }
}

String _$maintenanceRecordsStreamHash() =>
    r'4005366411918da52f1523911cc4dc5304b70a99';
