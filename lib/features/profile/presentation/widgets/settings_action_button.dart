import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';

class SettingsActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDark;
  final String languageCode;
  final bool showArrow;

  const SettingsActionButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    required this.isLoading,
    required this.isDark,
    required this.languageCode,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark
              : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark
              ? AppColors.textPrimaryDark
              : Colors.grey[900]!,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey[600]!,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : Colors.grey[900]!,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : Colors.grey[600]!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

