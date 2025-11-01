import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/maintenance_request_remote_datasource.dart';
import '../../data/repositories/maintenance_request_repository_impl.dart';
import '../../domain/entities/contract.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/maintenance_request.dart';
import '../../domain/repositories/maintenance_request_repository.dart';

part '../../../../generated/features/report/presentation/providers/maintenance_request_provider.g.dart';

/// Supabase client provider
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Datasource provider
@riverpod
MaintenanceRequestRemoteDatasource maintenanceRequestDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MaintenanceRequestRemoteDatasource(supabase);
}

/// Repository provider
@riverpod
MaintenanceRequestRepository maintenanceRequestRepository(Ref ref) {
  final datasource = ref.watch(maintenanceRequestDatasourceProvider);
  return MaintenanceRequestRepositoryImpl(datasource);
}

/// Get active contracts
@riverpod
Future<List<Contract>> activeContracts(Ref ref) async {
  final repository = ref.watch(maintenanceRequestRepositoryProvider);
  return repository.getActiveContracts();
}

/// Get maintenance requests list
@riverpod
Future<List<MaintenanceRequest>> maintenanceRequestsList(Ref ref) async {
  final repository = ref.watch(maintenanceRequestRepositoryProvider);
  return repository.getMaintenanceRequests();
}

/// Stream maintenance requests for realtime
@riverpod
Stream<List<MaintenanceRequest>> maintenanceRequestsStream(Ref ref) {
  final repository = ref.watch(maintenanceRequestRepositoryProvider);
  return repository.streamMaintenanceRequests();
}

/// Get maintenance request detail
@riverpod
Future<MaintenanceRequest> maintenanceRequestDetail(Ref ref, String id) async {
  final repository = ref.watch(maintenanceRequestRepositoryProvider);
  return repository.getMaintenanceRequestDetail(id);
}

/// Create maintenance request
@riverpod
class MaintenanceRequestCreator extends _$MaintenanceRequestCreator {
  @override
  FutureOr<MaintenanceRequest?> build() {
    // Keep provider alive during async operations
    ref.keepAlive();
    return null;
  }

  Future<void> create({
    required String description,
    required String propertiesId,
    required String roomId,
    List<String>? imagePaths,
  }) async {
    // Check if provider is still mounted before setting state
    if (!ref.mounted) return;

    try {
      state = const AsyncValue.loading();

      // Check again before async operation
      if (!ref.mounted) return;

      final repository = ref.read(maintenanceRequestRepositoryProvider);
      final request = await repository.createMaintenanceRequest(
        description: description,
        propertiesId: propertiesId,
        roomId: roomId,
        imagePaths: imagePaths,
      );

      // Check mounted again after async operation before setting state
      if (!ref.mounted) return;

      state = AsyncValue.data(request);

      // Invalidate list to refresh only if provider is still mounted
      if (ref.mounted) {
        ref.invalidate(maintenanceRequestsListProvider);
        ref.invalidate(maintenanceRequestsStreamProvider);
      }
    } catch (error, stackTrace) {
      // Only set error state if provider is still mounted
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
}

/// Cancel maintenance request - simple future provider approach
@riverpod
Future<void> cancelMaintenanceRequest(Ref ref, String id) async {
  // Check if provider is still mounted before async operation
  if (!ref.mounted) return;

  final repository = ref.read(maintenanceRequestRepositoryProvider);
  await repository.cancelMaintenanceRequest(id);

  // Check mounted again after async operation before invalidating
  if (ref.mounted) {
    ref.invalidate(maintenanceRequestsListProvider);
    ref.invalidate(maintenanceRequestsStreamProvider);
  }
}

/// Delete maintenance request - simple future provider approach
@riverpod
Future<void> deleteMaintenanceRequest(Ref ref, String id) async {
  // Check if provider is still mounted before async operation
  if (!ref.mounted) return;

  final repository = ref.read(maintenanceRequestRepositoryProvider);
  await repository.deleteMaintenanceRequest(id);

  // Check mounted again after async operation before invalidating
  if (ref.mounted) {
    ref.invalidate(maintenanceRequestsListProvider);
    ref.invalidate(maintenanceRequestsStreamProvider);
  }
}

/// Get maintenance records (READ-ONLY for tenant)
/// Fetches maintenance work for properties the tenant has active contracts with
/// Automatically filters out CANCELLED status
@riverpod
Future<List<Maintenance>> maintenanceRecords(Ref ref) async {
  final repository = ref.watch(maintenanceRequestRepositoryProvider);
  return repository.getMaintenanceRecords();
}

/// Stream maintenance records for realtime updates
@riverpod
Stream<List<Maintenance>> maintenanceRecordsStream(Ref ref) {
  final repository = ref.watch(maintenanceRequestRepositoryProvider);
  return repository.streamMaintenanceRecords();
}
