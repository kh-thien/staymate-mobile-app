import '../entities/contract_entity.dart';
import '../../data/models/contract_file_model.dart';

abstract class ContractRepository {
  /// Lấy tenant ID từ user ID
  Future<String?> getTenantIdByUserId(String userId);

  /// Lấy danh sách contracts của tenant
  Future<List<ContractEntity>> getContractsByTenantId(String tenantId);

  /// Lấy chi tiết hợp đồng
  Future<ContractEntity> getContractDetail(String contractId);

  /// Lấy danh sách file hợp đồng
  Future<List<ContractFileModel>> getContractFiles(String contractId);
}
