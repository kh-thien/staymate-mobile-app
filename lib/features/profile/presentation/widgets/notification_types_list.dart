import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class NotificationTypesList extends StatelessWidget {
  final bool isDark;
  final String languageCode;

  const NotificationTypesList({
    super.key,
    required this.isDark,
    required this.languageCode,
  });

  static List<Map<String, dynamic>> _getNotificationTypes(
    String languageCode,
  ) {
    return [
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'title': AppLocalizationsHelper.translate(
          'notificationTypeNewMessage',
          languageCode,
        ),
        'description': AppLocalizationsHelper.translate(
          'notificationTypeNewMessageDesc',
          languageCode,
        ),
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.description_outlined,
        'title': AppLocalizationsHelper.translate(
          'notificationTypeContractUpdate',
          languageCode,
        ),
        'description': AppLocalizationsHelper.translate(
          'notificationTypeContractUpdateDesc',
          languageCode,
        ),
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.receipt_long_outlined,
        'title': AppLocalizationsHelper.translate(
          'notificationTypeInvoice',
          languageCode,
        ),
        'description': AppLocalizationsHelper.translate(
          'notificationTypeInvoiceDesc',
          languageCode,
        ),
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Icons.flag_outlined,
        'title': AppLocalizationsHelper.translate(
          'notificationTypeNewReport',
          languageCode,
        ),
        'description': AppLocalizationsHelper.translate(
          'notificationTypeNewReportDesc',
          languageCode,
        ),
        'color': const Color(0xFFEF4444),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final types = _getNotificationTypes(languageCode);

    return Column(
      children: types.map((type) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDarkElevated
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isDark
                ? Border.all(
                    color: AppColors.borderDark,
                    width: 1,
                  )
                : null,
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (type['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type['icon'] as IconData,
                color: type['color'] as Color,
                size: 24,
              ),
            ),
            title: Text(
              type['title'] as String,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                type['description'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey[600]!,
                  height: 1.3,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

