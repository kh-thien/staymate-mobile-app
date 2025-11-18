import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class HomeSummaryRow extends StatelessWidget {
  const HomeSummaryRow({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: AppLocalizationsHelper.translate(
              'upcomingPayment',
              languageCode,
            ),
            value: '₫12,500,000',
            subtitle: AppLocalizationsHelper.translate(
              'dueSoon',
              languageCode,
            ),
            icon: Icons.payments_outlined,
            color: const Color(0xFFFFB347),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: AppLocalizationsHelper.translate(
              'maintenanceRooms',
              languageCode,
            ),
            value: '03',
            subtitle: AppLocalizationsHelper.translateWithParams(
              'maintenanceInProgress',
              languageCode,
              {'count': '03'},
            ),
            icon: Icons.report_problem_outlined,
            color: const Color(0xFF6EE7B7),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

