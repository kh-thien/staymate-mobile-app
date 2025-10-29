import '../entities/contract_entity.dart';
import '../repositories/contract_repository.dart';
import '../../data/models/contract_file_model.dart';

class GetContractDetailUseCase {
  final ContractRepository repository;

  GetContractDetailUseCase(this.repository);

  /// Get chi tiết hợp đồng
  ///
  /// Params:
  /// - [contractId]: ID của hợp đồng cần xem chi tiết
  ///
  /// Returns:
  /// - [ContractEntity] chứa thông tin contract
  /// - [List<ContractFileModel>] danh sách file hợp đồng
  ///
  /// Throws:
  /// - Exception nếu contract không tồn tại hoặc có lỗi khi query
  Future<(ContractEntity, List<ContractFileModel>)> call(
    String contractId,
  ) async {
    final contract = await repository.getContractDetail(contractId);
    final files = await repository.getContractFiles(contractId);
    return (contract, files);
  }
}
