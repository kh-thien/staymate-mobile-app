import 'package:flutter/material.dart';

/// Widget hiển thị trạng thái ký của một bên (landlord/tenant)
class ContractSignatureRow extends StatelessWidget {
  const ContractSignatureRow({
    super.key,
    required this.label,
    required this.isSigned,
  });

  final String label;
  final bool isSigned;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        Icon(
          isSigned ? Icons.check_circle : Icons.cancel,
          color: isSigned ? Colors.green : Colors.red,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          isSigned ? 'Đã ký' : 'Chưa ký',
          style: TextStyle(
            color: isSigned ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
