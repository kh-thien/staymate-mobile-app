import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/app_styles.dart';
import '../../domain/entities/contract_entity.dart';

/// Widget hiển thị một hợp đồng dạng card đơn giản, nhỏ gọn
class ContractCard extends ConsumerWidget {
  const ContractCard({super.key, required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final statusColor = _getStatusColor(contract.status);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.surfaceDarkElevated 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? AppColors.borderDark 
              : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: isDark
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(
              'contractDetail',
              pathParameters: {'id': contract.id},
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Header Row
                Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
                        Icons.description_rounded,
                        color: statusColor,
                        size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contract.contractNumber ??
                    AppLocalizationsHelper.translateWithParams(
                      'contractNumber',
                      languageCode,
                      {'id': contract.id.substring(0, 8)},
                    ),
                            style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                            overflow: TextOverflow.ellipsis,
              ),
                          const SizedBox(height: 4),
                          _StatusBadge(
                            status: contract.status,
                            statusTranslated: contract.getStatusTranslated(languageCode),
                            languageCode: languageCode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Room info (nếu có)
                if (contract.roomCode != null || contract.roomName != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.home_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          contract.roomDisplayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (contract.formattedAddress != 'N/A') ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                child: Text(
                        contract.formattedAddress,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 12),
                // Info section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withOpacity(0.08),
                        statusColor.withOpacity(0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizationsHelper.translate('rent', languageCode),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatCurrency(contract.monthlyRent)} ${AppLocalizationsHelper.translate('perMonth', languageCode)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (contract.startDate != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizationsHelper.translate('startDate', languageCode),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                  ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(contract.startDate!),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
                  ),
        ),
      ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFF10B981);
      case 'DRAFT':
        return const Color(0xFFF59E0B);
      case 'EXPIRED':
        return const Color(0xFFEF4444);
      case 'TERMINATED':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    // Format currency - Always use VND
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return currencyFormat.format(amount);
  }
}

// Status badge widget
class _StatusBadge extends StatelessWidget {
  final String status;
  final String statusTranslated;
  final String languageCode;

  const _StatusBadge({
    required this.status,
    required this.statusTranslated,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        backgroundColor = const Color(0xFF10B981);
        textColor = Colors.white;
        icon = Icons.check_circle_rounded;
        break;
      case 'DRAFT':
        backgroundColor = const Color(0xFFF59E0B);
        textColor = Colors.white;
        icon = Icons.edit_rounded;
        break;
      case 'EXPIRED':
        backgroundColor = const Color(0xFFEF4444);
        textColor = Colors.white;
        icon = Icons.schedule_rounded;
        break;
      case 'TERMINATED':
        backgroundColor = const Color(0xFF6B7280);
        textColor = Colors.white;
        icon = Icons.cancel_rounded;
        break;
      default:
        backgroundColor = const Color(0xFF3B82F6);
        textColor = Colors.white;
        icon = Icons.info_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            statusTranslated,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
