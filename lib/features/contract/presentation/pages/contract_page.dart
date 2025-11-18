import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../data/repositories/contract_repository_impl.dart';
import '../../domain/usecases/get_user_contracts_usecase.dart';
import '../providers/contract_provider.dart';
import '../widgets/widgets.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/providers/app_bar_provider.dart';


class ContractPage extends ConsumerStatefulWidget {
  const ContractPage({super.key});

  @override
  ConsumerState<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends ConsumerState<ContractPage> {
  late ContractCubit _contractCubit;
  late AuthService _authService;
  AppBarNotifier? _appBarNotifier;
  bool _hasSetTitle = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set AppBar title only once when page is first mounted
    if (!_hasSetTitle) {
      _appBarNotifier ??= ref.read(appBarProvider.notifier);
      final locale = ref.read(appLocaleProvider);
      final languageCode = locale.languageCode;
      // Use a small delay to ensure this runs after any cleanup from previous page
      Future.microtask(() {
        if (mounted) {
          _appBarNotifier?.updateTitle(
            AppLocalizationsHelper.translate('contracts', languageCode),
          );
        }
      });
      _hasSetTitle = true;
    }
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
    // Don't reset title here - let the next page set its own title
    // Only HomePage should reset title to show logo
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update title if locale changes (but only if we've already set it)
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    
    if (_hasSetTitle && _appBarNotifier != null && mounted) {
      // Update title when locale changes, but use a small delay to avoid race conditions
      Future.microtask(() {
        if (mounted) {
          _appBarNotifier?.updateTitle(
            AppLocalizationsHelper.translate('contracts', languageCode),
          );
        }
      });
    }
    
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
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(
                            bottom: UIConstants.bottomNavTotalHeight,
                          ),
                          itemCount: 5,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return const ContractCardSkeleton();
                          },
                        ),
                      )
                    else if (state is ContractLoaded &&
                        state.contracts.isNotEmpty) ...[
                      Text(
                        AppLocalizationsHelper.translateWithParams(
                          'contractListCount',
                          ref.watch(appLocaleProvider).languageCode,
                          {'count': state.contracts.length.toString()},
                        ),
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
                      Expanded(child: ContractEmptyState(onRefresh: _loadContracts)),
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
