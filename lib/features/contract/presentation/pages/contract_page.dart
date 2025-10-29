import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _authService = AuthService();

    // Initialize cubit
    final repository = ContractRepositoryImpl();
    final useCase = GetUserContractsUseCase(repository);
    _contractCubit = ContractCubit(getUserContractsUseCase: useCase);

    // Load contracts
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    final user = _authService.currentUser;
    if (user != null) {
      await _contractCubit.loadUserContracts(user.id);
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
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'Theo dõi hợp đồng trọ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Quản lý và theo dõi tình trạng hợp đồng thuê trọ',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),

                    // Contract Status Card
                    ContractStatusCard(state: state),
                    const SizedBox(height: 20),

                    // Contracts List
                    if (state is ContractLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (state is ContractLoaded &&
                        state.contracts.isNotEmpty) ...[
                      const Text(
                        'Danh sách hợp đồng',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
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
                    else
                      const Expanded(child: ContractEmptyState()),
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
