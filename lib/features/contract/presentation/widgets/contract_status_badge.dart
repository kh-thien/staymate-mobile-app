import 'package:flutter/material.dart';

/// Widget hiển thị badge trạng thái hợp đồng với màu sắc
class ContractStatusBadge extends StatelessWidget {
  const ContractStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ĐANG HOẠT ĐỘNG':
        return Colors.green;
      case 'HẾT HẠN':
        return Colors.orange;
      case 'ĐÃ CHẤM DỨT':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
