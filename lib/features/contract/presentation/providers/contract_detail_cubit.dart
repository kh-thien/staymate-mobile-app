import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/usecases/get_contract_detail_usecase.dart';
import '../../data/models/contract_file_model.dart';

// States
abstract class ContractDetailState {
  const ContractDetailState();
}

class ContractDetailInitial extends ContractDetailState {
  const ContractDetailInitial();
}

class ContractDetailLoading extends ContractDetailState {
  const ContractDetailLoading();
}

class ContractDetailLoaded extends ContractDetailState {
  const ContractDetailLoaded(this.contract, this.files);

  final ContractEntity contract;
  final List<ContractFileModel> files;
}

class ContractDetailError extends ContractDetailState {
  const ContractDetailError(this.message);

  final String message;
}

// Cubit
class ContractDetailCubit extends Cubit<ContractDetailState> {
  final GetContractDetailUseCase getContractDetailUseCase;

  ContractDetailCubit({required this.getContractDetailUseCase})
    : super(const ContractDetailInitial());

  /// Load chi tiết hợp đồng
  Future<void> loadContractDetail(String contractId) async {
    emit(const ContractDetailLoading());

    try {
      final (contract, files) = await getContractDetailUseCase(contractId);
      emit(ContractDetailLoaded(contract, files));
    } catch (e) {
      emit(ContractDetailError('Không thể tải chi tiết hợp đồng: $e'));
    }
  }

  /// Refresh contract detail
  Future<void> refresh(String contractId) async {
    await loadContractDetail(contractId);
  }
}
