import '../entities/contract.dart';
import '../entities/maintenance.dart';
import '../entities/maintenance_request.dart';

abstract class MaintenanceRequestRepository {
  /// Get active contracts for current user
  Future<List<Contract>> getActiveContracts();

  /// Get all maintenance requests for current user
  Future<List<MaintenanceRequest>> getMaintenanceRequests();

  /// Get maintenance request detail by id
  Future<MaintenanceRequest> getMaintenanceRequestDetail(String id);

  /// Create a new maintenance request
  Future<MaintenanceRequest> createMaintenanceRequest({
    required String description,
    required String propertiesId,
    required String roomId,
    List<String>? imagePaths,
  });

  /// Stream maintenance requests for realtime updates
  Stream<List<MaintenanceRequest>> streamMaintenanceRequests();

  /// Cancel a maintenance request
  Future<void> cancelMaintenanceRequest(String id);

  /// Delete a maintenance request
  Future<void> deleteMaintenanceRequest(String id);

  /// Get maintenance records for tenant's contracted properties (READ-ONLY)
  /// Filters out CANCELLED status as tenant should not see cancelled maintenance
  Future<List<Maintenance>> getMaintenanceRecords();

  /// Stream maintenance records for realtime updates
  Stream<List<Maintenance>> streamMaintenanceRecords();
}
