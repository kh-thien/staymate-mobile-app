import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/usecases/get_user_contracts_usecase.dart';

// States
abstract class ContractState {
  const ContractState();

  // Helper getter for contract count
  int get contractCount {
    if (this is ContractLoaded) {
      return (this as ContractLoaded).contracts.length;
    }
    return 0;
  }

  // Helper getter for contracts list
  List<ContractEntity> get contracts {
    if (this is ContractLoaded) {
      return (this as ContractLoaded).contracts;
    }
    return [];
  }
}

class ContractInitial extends ContractState {
  const ContractInitial();
}

class ContractLoading extends ContractState {
  const ContractLoading();
}

class ContractLoaded extends ContractState {
  const ContractLoaded(this.contracts);

  @override
  final List<ContractEntity> contracts;
}

class ContractError extends ContractState {
  const ContractError(this.message);

  final String message;
}

// Cubit
class ContractCubit extends Cubit<ContractState> {
  final GetUserContractsUseCase getUserContractsUseCase;

  ContractCubit({required this.getUserContractsUseCase})
    : super(const ContractInitial());

  /// Load contracts của user hiện tại
  Future<void> loadUserContracts(String userId) async {
    developer.log(
      '🔄 [ContractCubit] Loading contracts for user: $userId',
      name: 'ContractCubit',
    );
    emit(const ContractLoading());

    try {
      final contracts = await getUserContractsUseCase(userId);
      developer.log(
        '✅ [ContractCubit] Loaded ${contracts.length} contracts',
        name: 'ContractCubit',
      );
      emit(ContractLoaded(contracts));
    } catch (e, stackTrace) {
      developer.log(
        '❌ [ContractCubit] Error loading contracts: $e',
        name: 'ContractCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(ContractError(e.toString()));
    }
  }

  /// Refresh contracts
  Future<void> refresh(String userId) async {
    await loadUserContracts(userId);
  }
}
