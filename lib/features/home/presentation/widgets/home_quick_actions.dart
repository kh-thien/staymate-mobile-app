import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/app_styles.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionData(
        label: AppLocalizationsHelper.translate('contracts', languageCode),
        icon: Icons.description_rounded,
        color: const Color(0xFF93C5FD),
        route: '/contract',
      ),
      _QuickActionData(
        label: AppLocalizationsHelper.translate('invoices', languageCode),
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFFFFF59D),
        route: '/invoice',
      ),
      _QuickActionData(
        label: AppLocalizationsHelper.translate('reports', languageCode),
        icon: Icons.build_circle_outlined,
        color: const Color(0xFFFFD6E8),
        route: '/report',
      ),
      _QuickActionData(
        label: AppLocalizationsHelper.translate('notifications', languageCode),
        icon: Icons.notifications_active_outlined,
        color: const Color(0xFFB5F5EC),
        route: '/notifications',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizationsHelper.translate('quickActions', languageCode),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: actions
                  .map(
                    (action) => _QuickActionButton(
                      data: action,
                      width: itemWidth,
                      onTap: () => context.go(action.route),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class _QuickActionData {
  _QuickActionData({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.data,
    required this.onTap,
    required this.width,
  });

  final _QuickActionData data;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark 
        ? AppColors.textPrimaryDark 
        : const Color(0xFF1F2937);
    
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDarkElevated
                : data.color.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16),
            border: isDark
                ? Border.all(
                    color: AppColors.borderDark,
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? data.color.withOpacity(0.3)
                      : data.color.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  data.icon,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                data.label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

