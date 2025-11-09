import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/repositories/contract_repository_impl.dart';
import '../../domain/usecases/get_user_contracts_usecase.dart';
import '../providers/contract_provider.dart';
import '../widgets/widgets.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  late ContractCubit _contractCubit;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    print('🚀🚀🚀 [ContractPage] initState called 🚀🚀🚀');
    developer.log(
      '🚀 [ContractPage] initState called',
      name: 'ContractPage',
    );
    _authService = AuthService();

    // Initialize cubit
    final repository = ContractRepositoryImpl();
    final useCase = GetUserContractsUseCase(repository);
    _contractCubit = ContractCubit(getUserContractsUseCase: useCase);

    // Load contracts
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    print('📞📞📞 [ContractPage] _loadContracts called 📞📞📞');
    developer.log(
      '📞 [ContractPage] _loadContracts called',
      name: 'ContractPage',
    );
    final user = _authService.currentUser;
    print('👤👤👤 [ContractPage] Current user: ${user?.id ?? "NULL"} 👤👤👤');
    developer.log(
      '👤 [ContractPage] Current user: ${user?.id ?? "NULL"}',
      name: 'ContractPage',
    );
    if (user != null) {
      print('✅✅✅ [ContractPage] User found, loading contracts for: ${user.id} ✅✅✅');
      developer.log(
        '✅ [ContractPage] User found, loading contracts for: ${user.id}',
        name: 'ContractPage',
      );
      await _contractCubit.loadUserContracts(user.id);
    } else {
      print('⚠️⚠️⚠️ [ContractPage] User is NULL, cannot load contracts ⚠️⚠️⚠️');
      developer.log(
        '⚠️ [ContractPage] User is NULL, cannot load contracts',
        name: 'ContractPage',
      );
    }
  }

  @override
  void dispose() {
    _contractCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: RefreshIndicator(
          onRefresh: _loadContracts,
          child: BlocBuilder<ContractCubit, ContractState>(
            bloc: _contractCubit,
            builder: (context, state) {
              developer.log(
                '🔄 [ContractPage] State changed: ${state.runtimeType}',
                name: 'ContractPage',
              );
              if (state is ContractLoaded) {
                developer.log(
                  '📋 [ContractPage] Contracts loaded: ${state.contracts.length}',
                  name: 'ContractPage',
                );
              } else if (state is ContractError) {
                developer.log(
                  '❌ [ContractPage] Error: ${state.message}',
                  name: 'ContractPage',
                );
              }
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contracts List
                    if (state is ContractLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (state is ContractLoaded &&
                        state.contracts.isNotEmpty) ...[
                      Text(
                        'Danh sách hợp đồng (${state.contracts.length})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(
                            bottom: UIConstants.bottomNavTotalHeight,
                          ),
                          itemCount: state.contracts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final contract = state.contracts[index];
                            return ContractCard(contract: contract);
                          },
                        ),
                      ),
                    ] else if (state is ContractError)
                      Expanded(
                        child: ContractErrorState(
                          message: state.message,
                          onRetry: _loadContracts,
                        ),
                      )
                    else ...[
                      // Contract Status Card - chỉ hiển thị khi không có hợp đồng
                      ContractStatusCard(state: state),
                      const SizedBox(height: 20),
                      const Expanded(child: ContractEmptyState()),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
