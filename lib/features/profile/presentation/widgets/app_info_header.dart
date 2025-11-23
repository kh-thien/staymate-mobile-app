import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/constants/logo_app.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class AppInfoHeader extends StatelessWidget {
  final PackageInfo packageInfo;
  final String languageCode;
  final bool isDark;

  const AppInfoHeader({
    super.key,
    required this.packageInfo,
    required this.languageCode,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final currentVersion = '${packageInfo.version} (${packageInfo.buildNumber})';

    return Column(
      children: [
        // App Logo/Icon Section
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                LogoApp.logoIcon,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.amberAccent,
                    child: const Icon(
                      Icons.home_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // App Name
        Center(
          child: Text(
            packageInfo.appName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF2D3748),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Current Version
        Center(
          child: Text(
            '${AppLocalizationsHelper.translate('version', languageCode)}: $currentVersion',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey[600]!,
            ),
          ),
        ),
      ],
    );
  }
}

