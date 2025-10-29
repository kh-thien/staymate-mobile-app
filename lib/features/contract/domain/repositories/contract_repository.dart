import '../entities/contract_entity.dart';

abstract class ContractRepository {
  /// Lấy tenant ID từ user ID
  Future<String?> getTenantIdByUserId(String userId);

  /// Lấy danh sách contracts của tenant
  Future<List<ContractEntity>> getContractsByTenantId(String tenantId);
}
