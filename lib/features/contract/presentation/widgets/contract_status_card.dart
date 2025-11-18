import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/contract_provider.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';

/// Widget hiển thị tổng quan trạng thái hợp đồng
class ContractStatusCard extends ConsumerWidget {
  const ContractStatusCard({super.key, required this.state});

  final ContractState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final contractCount = state is ContractLoaded ? state.contractCount : 0;
    final hasContracts = contractCount > 0;
    final isLoading = state is ContractLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasContracts
              ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
              : [Colors.grey.shade400, Colors.grey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (hasContracts ? const Color(0xFF667eea) : Colors.grey)
                .withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                AppLocalizationsHelper.translate('contractStatus', languageCode),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            Text(
              AppLocalizationsHelper.translate('loading', languageCode),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            )
          else if (hasContracts)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizationsHelper.translate('contractCount', languageCode)}: $contractCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizationsHelper.translateWithParams(
                    'youHaveContracts',
                    languageCode,
                    {'count': contractCount.toString()},
                  ),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizationsHelper.translate('noContractYet', languageCode),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizationsHelper.translate('contactLandlordToCreateRentalContract', languageCode),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
