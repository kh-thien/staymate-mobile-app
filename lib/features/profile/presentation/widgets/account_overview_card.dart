import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class AccountOverviewCard extends StatelessWidget {
  const AccountOverviewCard({
    super.key,
    required this.email,
    required this.userId,
    required this.provider,
    required this.languageCode,
  });

  final String email;
  final String userId;
  final String provider;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.surfaceDark
                      : const Color(0xFFE0E7FF),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizationsHelper.translateWithParams(
                        'userIdLabel',
                        languageCode,
                        {'userId': userId},
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _Tag(
                icon: Icons.key_rounded,
                label: AppLocalizationsHelper.translateWithParams(
                  'loginProviderLabel',
                  languageCode,
                  {'provider': provider},
                ),
                isDark: isDark,
              ),
              _Tag(
                icon: Icons.shield_outlined,
                label: AppLocalizationsHelper.translate(
                  'secureLogin',
                  languageCode,
                ),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark
                ? AppColors.textPrimaryDark
                : const Color(0xFF4F46E5),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}

