import 'package:flutter/material.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class DeleteAccountSection extends StatelessWidget {
  const DeleteAccountSection({
    super.key,
    required this.languageCode,
    required this.isDark,
    required this.isLoading,
    required this.onDeleteTap,
  });

  final String languageCode;
  final bool isDark;
  final bool isLoading;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isDark
        ? AppColors.surfaceDarkElevated
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent.withOpacity(0.8),
                      Colors.deepOrangeAccent,
                    ],
                  ),
                ),
                child: const Icon(Icons.shield_outlined, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizationsHelper.translate(
                        'deleteAccount',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizationsHelper.translate(
                        'deleteAccountDescription',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GuidelineTile(
            languageCode: languageCode,
            icon: Icons.lock_outline,
            textKey: 'deleteAccountDataWipe',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _GuidelineTile(
            languageCode: languageCode,
            icon: Icons.timer_off_outlined,
            textKey: 'deleteAccountIrreversible',
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: isLoading ? null : onDeleteTap,
            icon: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.delete_forever_rounded),
            label: Text(
              AppLocalizationsHelper.translate(
                'deleteAccountConfirm',
                languageCode,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent.shade400,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidelineTile extends StatelessWidget {
  const _GuidelineTile({
    required this.languageCode,
    required this.icon,
    required this.textKey,
    required this.isDark,
  });

  final String languageCode;
  final IconData icon;
  final String textKey;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.redAccent.shade100 : Colors.redAccent,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            AppLocalizationsHelper.translate(textKey, languageCode),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
