import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class SocialLoginNotice extends StatelessWidget {
  const SocialLoginNotice({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFF93C5FD),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.surfaceDark : Colors.white,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color:
                  isDark ? AppColors.textSecondaryDark : const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizationsHelper.translate(
                'passwordChangeNotAvailableForSocialLogin',
                languageCode,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

