import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';

class GetUserContractsUseCase {
  final ContractRepository repository;

  GetUserContractsUseCase(this.repository);

  /// Lấy danh sách hợp đồng của user hiện tại
  ///
  /// Flow:
  /// 1. Lấy tenant_id từ user_id
  /// 2. Nếu có tenant_id, lấy danh sách contracts
  /// 3. Trả về danh sách contracts
  Future<List<ContractEntity>> call(String userId) async {
    // Bước 1: Lấy tenant_id từ user_id
    final tenantId = await repository.getTenantIdByUserId(userId);

    if (tenantId == null) {
      return [];
    }

    // Bước 2: Lấy danh sách contracts theo tenant_id
    final contracts = await repository.getContractsByTenantId(tenantId);

    return contracts;
  }
}
