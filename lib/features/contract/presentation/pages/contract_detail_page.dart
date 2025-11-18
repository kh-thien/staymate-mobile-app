import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../domain/entities/contract_entity.dart';
import '../../data/models/contract_file_model.dart';
import '../providers/contract_detail_cubit.dart';
import '../widgets/widgets.dart';
import 'contract_files_viewer_page.dart';

/// Contract Detail Page - shows full details of a contract
class ContractDetailPage extends StatelessWidget {
  const ContractDetailPage({
    super.key,
    required this.contractId,
    required this.cubit,
  });

  final String contractId;
  final ContractDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..loadContractDetail(contractId),
      child: _ContractDetailView(contractId: contractId),
    );
  }
}

class _ContractDetailView extends StatelessWidget {
  const _ContractDetailView({required this.contractId});

  final String contractId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ContractDetailCubit, ContractDetailState>(
        builder: (context, state) {
          if (state is ContractDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ContractDetailError) {
            return ContractDetailErrorView(
              message: state.message,
              onRetry: () => context
                  .read<ContractDetailCubit>()
                  .loadContractDetail(contractId),
            );
          }

          if (state is ContractDetailLoaded) {
            return _LoadedView(contract: state.contract, files: state.files);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LoadedView extends ConsumerWidget {
  const _LoadedView({required this.contract, required this.files});

  final ContractEntity contract;
  final List<ContractFileModel> files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: languageCode == 'vi' ? 'vi_VN' : 'en_US',
      symbol: languageCode == 'vi' ? '₫' : '\$',
      decimalDigits: 0,
    );
    final statusColor = _getStatusColor(contract.status);

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar:  AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        title: Text(
          AppLocalizationsHelper.translate('contractDetail', languageCode),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.insert_drive_file,
              color: Colors.black87,
            ),
            tooltip: AppLocalizationsHelper.translateWithParams(
              'viewContractFiles',
              languageCode,
              {'count': files.length.toString()},
            ),
            onPressed: () {
              if (files.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizationsHelper.translate(
                        'noContractFiles',
                        languageCode,
                      ),
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ContractFilesViewerPage(files: files, initialIndex: 0),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ContractDetailCubit>().loadContractDetail(contract.id);
        },
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 16.0 + UIConstants.bottomNavTotalHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header card
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                      AppLocalizationsHelper.translate(
                                        'notAvailable',
                                        languageCode,
                                      ),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _StatusBadge(
                                  status: contract.status,
                                  statusInVietnamese: contract.statusInVietnamese,
                                  languageCode: languageCode,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (contract.roomCode != null ||
                          contract.roomName != null) ...[
                        const SizedBox(height: 12),
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
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),

              // Thông tin hợp đồng
              _SectionCard(
                title: AppLocalizationsHelper.translate('contractInfo', languageCode),
                languageCode: languageCode,
                child: Column(
                  children: [
                    _InfoRow(
                      label: AppLocalizationsHelper.translate('contractType', languageCode),
                      value: contract.contractTypeInVietnamese,
                      languageCode: languageCode,
                    ),
                    if (contract.startDate != null)
                      _InfoRow(
                        label: AppLocalizationsHelper.translate('startDate', languageCode),
                        value: dateFormat.format(contract.startDate!),
                        languageCode: languageCode,
                      ),
                    if (contract.endDate != null)
                      _InfoRow(
                        label: AppLocalizationsHelper.translate('endDate', languageCode),
                        value: dateFormat.format(contract.endDate!),
                        languageCode: languageCode,
                      ),
                    _InfoRow(
                      label: AppLocalizationsHelper.translate('autoRenewal', languageCode),
                      value: (contract.autoRenewal ?? false)
                          ? AppLocalizationsHelper.translate('yes', languageCode)
                          : AppLocalizationsHelper.translate('no', languageCode),
                      languageCode: languageCode,
                    ),
                    if (contract.noticePeriodDays != null)
                      _InfoRow(
                        label: AppLocalizationsHelper.translate('noticePeriod', languageCode),
                        value: '${contract.noticePeriodDays} ${AppLocalizationsHelper.translate('days', languageCode)}',
                        languageCode: languageCode,
                      ),
                    if (contract.specialTerms != null) ...[
                      const Divider(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          contract.specialTerms!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Thông tin thanh toán
              _SectionCard(
                title: AppLocalizationsHelper.translate('paymentInfo', languageCode),
                languageCode: languageCode,
                child: Column(
                  children: [
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizationsHelper.translate('monthlyRent', languageCode),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormat.format(contract.monthlyRent),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizationsHelper.translate('deposit', languageCode),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormat.format(contract.deposit),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: AppLocalizationsHelper.translate('paymentCycle', languageCode),
                      value: contract.paymentCycleInVietnamese,
                      languageCode: languageCode,
                    ),
                    if (contract.paymentFrequency != null)
                      _InfoRow(
                        label: AppLocalizationsHelper.translate('paymentFrequency', languageCode),
                        value: '${contract.paymentFrequency} ${AppLocalizationsHelper.translate('timesPerCycle', languageCode)}',
                        languageCode: languageCode,
                      ),
                    _InfoRow(
                      label: AppLocalizationsHelper.translate('paymentDayType', languageCode),
                      value: contract.paymentDayTypeInVietnamese,
                      languageCode: languageCode,
                    ),
                    if (contract.paymentDay != null)
                      _InfoRow(
                        label: AppLocalizationsHelper.translate('paymentDay', languageCode),
                        value: '${AppLocalizationsHelper.translate('day', languageCode)} ${contract.paymentDay}',
                        languageCode: languageCode,
                      ),
                    if (contract.paymentDays != null &&
                        (contract.paymentDays!).isNotEmpty) ...[
                      const Divider(height: 20),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: (contract.paymentDays!)
                            .map(
                              (day) => Chip(
                                label: Text(
                                  '${AppLocalizationsHelper.translate('day', languageCode)} $day',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Tình trạng ký kết
              if (contract.hasSignature)
                _SectionCard(
                  title: AppLocalizationsHelper.translate('signingStatus', languageCode),
                  languageCode: languageCode,
                  child: Column(
                    children: [
                      _SignatureRow(
                        label: AppLocalizationsHelper.translate('landlordSigned', languageCode),
                        isSigned: contract.signedByLandlord ?? false,
                        languageCode: languageCode,
                      ),
                      const SizedBox(height: 12),
                      _SignatureRow(
                        label: AppLocalizationsHelper.translate('tenantSigned', languageCode),
                        isSigned: contract.signedByTenant ?? false,
                        languageCode: languageCode,
                      ),
                      if (contract.signedAt != null) ...[
                        const Divider(height: 20),
                        _InfoRow(
                          label: AppLocalizationsHelper.translate('signingDate', languageCode),
                          value: dateFormat.format(contract.signedAt!),
                          languageCode: languageCode,
                        ),
                      ],
                    ],
                  ),
                ),

              // Thông tin chấm dứt
              if (contract.isTerminated)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizationsHelper.translate('terminationInfo', languageCode),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (contract.terminationReason != null)
                          _InfoRow(
                            label: AppLocalizationsHelper.translate('reason', languageCode),
                            value: contract.terminationReason!.displayName,
                            languageCode: languageCode,
                          ),
                        if (contract.terminationNote != null) ...[
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: AppLocalizationsHelper.translate('note', languageCode),
                            value: contract.terminationNote!,
                            languageCode: languageCode,
                          ),
                        ],
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: AppLocalizationsHelper.translate('earlyTermination', languageCode),
                          value: (contract.isEarlyTermination ?? false)
                              ? AppLocalizationsHelper.translate('yes', languageCode)
                              : AppLocalizationsHelper.translate('no', languageCode),
                          languageCode: languageCode,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),
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
}

// Section Card Widget
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String languageCode;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String languageCode;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Signature Row Widget
class _SignatureRow extends StatelessWidget {
  final String label;
  final bool isSigned;
  final String languageCode;

  const _SignatureRow({
    required this.label,
    required this.isSigned,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Icon(
              isSigned ? Icons.check_circle : Icons.cancel,
              color: isSigned ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              isSigned
                  ? AppLocalizationsHelper.translate('signed', languageCode)
                  : AppLocalizationsHelper.translate('notSigned', languageCode),
              style: TextStyle(
                fontSize: 14,
                color: isSigned ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Status Badge Widget
class _StatusBadge extends StatelessWidget {
  final String status;
  final String statusInVietnamese;
  final String languageCode;

  const _StatusBadge({
    required this.status,
    required this.statusInVietnamese,
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
            statusInVietnamese,
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
