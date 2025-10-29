import 'package:flutter/material.dart';
import '../providers/contract_provider.dart';

/// Widget hiển thị tổng quan trạng thái hợp đồng
class ContractStatusCard extends StatelessWidget {
  const ContractStatusCard({super.key, required this.state});

  final ContractState state;

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: [
              Icon(Icons.description_rounded, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Trạng thái hợp đồng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Text(
              'Đang tải...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            )
          else if (hasContracts)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số hợp đồng: $contractCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bạn có $contractCount hợp đồng thuê trọ',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            )
          else
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chưa có hợp đồng',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Liên hệ với chủ nhà để tạo hợp đồng thuê trọ',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
