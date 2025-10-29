import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.contract, required this.files});

  final ContractEntity contract;
  final List<ContractFileModel> files;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: Text(contract.contractNumber ?? 'Chi tiết hợp đồng'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_drive_file),
            tooltip: 'Xem file hợp đồng (${files.length})',
            onPressed: () {
              if (files.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chưa có file hợp đồng')),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏠 Phần 1 — Thông tin hợp đồng
              const ContractSectionTitle('🏠 Thông tin hợp đồng'),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ContractDetailInfoRow(
                        label: 'Số hợp đồng',
                        value: contract.contractNumber ?? 'Chưa có',
                      ),
                      // Trạng thái với badge màu
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 150,
                              child: Text(
                                'Trạng thái:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            ContractStatusBadge(
                              status: contract.statusInVietnamese,
                            ),
                          ],
                        ),
                      ),
                      ContractDetailInfoRow(
                        label: 'Loại hợp đồng',
                        value: contract.contractTypeInVietnamese,
                      ),
                      if (contract.startDate != null)
                        ContractDetailInfoRow(
                          label: 'Ngày bắt đầu',
                          value: dateFormat.format(contract.startDate!),
                        ),
                      if (contract.endDate != null)
                        ContractDetailInfoRow(
                          label: 'Ngày kết thúc',
                          value: dateFormat.format(contract.endDate!),
                        ),
                      ContractDetailInfoRow(
                        label: 'Gia hạn tự động',
                        value: (contract.autoRenewal ?? false) ? 'Có' : 'Không',
                      ),
                      if (contract.noticePeriodDays != null)
                        ContractDetailInfoRow(
                          label: 'Thời gian báo hủy',
                          value: '${contract.noticePeriodDays} ngày',
                        ),
                      if (contract.specialTerms != null) ...[
                        const Divider(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ghi chú đặc biệt:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            contract.specialTerms!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 💵 Phần 2 — Thông tin thanh toán
              const ContractSectionTitle('💵 Thông tin thanh toán'),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ContractDetailInfoRow(
                        label: 'Tiền thuê hàng tháng',
                        value: currencyFormat.format(contract.monthlyRent),
                        valueStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      ContractDetailInfoRow(
                        label: 'Tiền cọc',
                        value: currencyFormat.format(contract.deposit),
                      ),
                      ContractDetailInfoRow(
                        label: 'Chu kỳ thanh toán',
                        value: contract.paymentCycleInVietnamese,
                      ),
                      if (contract.paymentFrequency != null)
                        ContractDetailInfoRow(
                          label: 'Tần suất thanh toán',
                          value: '${contract.paymentFrequency} lần/chu kỳ',
                        ),
                      ContractDetailInfoRow(
                        label: 'Loại ngày thanh toán',
                        value: contract.paymentDayTypeInVietnamese,
                      ),
                      if (contract.paymentDay != null)
                        ContractDetailInfoRow(
                          label: 'Ngày thanh toán',
                          value: 'Ngày ${contract.paymentDay}',
                        ),
                      if (contract.paymentDays != null &&
                          (contract.paymentDays!).isNotEmpty) ...[
                        const Divider(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Các ngày thanh toán:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (contract.paymentDays!)
                              .map(
                                (day) => Chip(
                                  label: Text('Ngày $day'),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ✍️ Phần 3 — Tình trạng ký kết
              if (contract.hasSignature) ...[
                const ContractSectionTitle('✍️ Tình trạng ký kết'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ContractSignatureRow(
                          label: 'Chủ nhà đã ký',
                          isSigned: contract.signedByLandlord ?? false,
                        ),
                        const SizedBox(height: 12),
                        ContractSignatureRow(
                          label: 'Người thuê đã ký',
                          isSigned: contract.signedByTenant ?? false,
                        ),
                        if (contract.signedAt != null) ...[
                          const Divider(height: 24),
                          ContractDetailInfoRow(
                            label: 'Ngày ký',
                            value: dateFormat.format(contract.signedAt!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ⚠️ Phần 5 — Thông tin chấm dứt
              if (contract.isTerminated) ...[
                const ContractSectionTitle('⚠️ Thông tin chấm dứt'),
                const SizedBox(height: 12),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (contract.terminationReason != null) ...[
                          const Text(
                            'Lý do:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contract.terminationReason!,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (contract.terminationNote != null) ...[
                          const Text(
                            'Ghi chú:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contract.terminationNote!,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 12),
                        ],
                        ContractDetailInfoRow(
                          label: 'Chấm dứt sớm',
                          value: (contract.isEarlyTermination ?? false)
                              ? 'Có'
                              : 'Không',
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
