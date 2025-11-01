import '../../domain/entities/contract.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/maintenance_request.dart';
import '../../domain/repositories/maintenance_request_repository.dart';
import '../datasources/maintenance_request_remote_datasource.dart';

class MaintenanceRequestRepositoryImpl implements MaintenanceRequestRepository {
  final MaintenanceRequestRemoteDatasource _datasource;

  MaintenanceRequestRepositoryImpl(this._datasource);

  @override
  Future<List<Contract>> getActiveContracts() async {
    try {
      final models = await _datasource.getActiveContracts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get active contracts: $e');
    }
  }

  @override
  Future<List<MaintenanceRequest>> getMaintenanceRequests() async {
    try {
      final models = await _datasource.getMaintenanceRequests();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get maintenance requests: $e');
    }
  }

  @override
  Future<MaintenanceRequest> getMaintenanceRequestDetail(String id) async {
    try {
      final model = await _datasource.getMaintenanceRequestDetail(id);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get maintenance request detail: $e');
    }
  }

  @override
  Future<MaintenanceRequest> createMaintenanceRequest({
    required String description,
    required String propertiesId,
    required String roomId,
    List<String>? imagePaths,
  }) async {
    try {
      final model = await _datasource.createMaintenanceRequest(
        description: description,
        propertiesId: propertiesId,
        roomId: roomId,
        imagePaths: imagePaths,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to create maintenance request: $e');
    }
  }

  @override
  Stream<List<MaintenanceRequest>> streamMaintenanceRequests() {
    return _datasource.streamMaintenanceRequests().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> cancelMaintenanceRequest(String id) async {
    try {
      await _datasource.cancelMaintenanceRequest(id);
    } catch (e) {
      throw Exception('Failed to cancel maintenance request: $e');
    }
  }

  @override
  Future<void> deleteMaintenanceRequest(String id) async {
    try {
      await _datasource.deleteMaintenanceRequest(id);
    } catch (e) {
      throw Exception('Failed to delete maintenance request: $e');
    }
  }

  @override
  Future<List<Maintenance>> getMaintenanceRecords() async {
    try {
      final models = await _datasource.getMaintenanceRecords();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get maintenance records: $e');
    }
  }

  @override
  Stream<List<Maintenance>> streamMaintenanceRecords() {
    return _datasource.streamMaintenanceRecords().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}
