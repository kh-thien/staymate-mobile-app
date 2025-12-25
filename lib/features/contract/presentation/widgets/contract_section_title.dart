import 'package:flutter/material.dart';

/// Widget hiển thị tiêu đề cho mỗi section
class ContractSectionTitle extends StatelessWidget {
  const ContractSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
