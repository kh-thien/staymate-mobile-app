import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/contract_entity.dart';
import 'contract_info_row.dart';

/// Widget hiển thị một hợp đồng dạng card
class ContractCard extends StatelessWidget {
  const ContractCard({super.key, required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'contractDetail',
          pathParameters: {'id': contract.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              _buildInfoSection(),
              const SizedBox(height: 12),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStatusColor(contract.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.assignment,
            color: _getStatusColor(contract.status),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contract.contractNumber ??
                    'Hợp đồng #${contract.id.substring(0, 8)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    contract.status,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  contract.statusInVietnamese,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(contract.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        ContractInfoRow(
          icon: Icons.calendar_today,
          label: 'Ngày bắt đầu',
          value: contract.startDate != null
              ? _formatDate(contract.startDate!)
              : 'Chưa xác định',
        ),
        const SizedBox(height: 8),
        ContractInfoRow(
          icon: Icons.event,
          label: 'Ngày kết thúc',
          value: contract.endDate != null
              ? _formatDate(contract.endDate!)
              : 'Chưa xác định',
        ),
        const SizedBox(height: 8),
        ContractInfoRow(
          icon: Icons.attach_money,
          label: 'Tiền thuê',
          value: '${_formatCurrency(contract.monthlyRent)}/tháng',
        ),
        const SizedBox(height: 8),
        ContractInfoRow(
          icon: Icons.account_balance_wallet,
          label: 'Tiền cọc',
          value: _formatCurrency(contract.deposit),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () {
            context.pushNamed(
              'contractDetail',
              pathParameters: {'id': contract.id},
            );
          },
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text('Xem chi tiết'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF4F46E5)),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'DRAFT':
        return Colors.orange;
      case 'EXPIRED':
        return Colors.red;
      case 'TERMINATED':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} đ';
  }
}
