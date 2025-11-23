import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

enum UpdateStatus {
  checking,
  upToDate,
  updateAvailable,
  error,
  notSupported,
}

class VersionStatusCard extends StatelessWidget {
  final UpdateStatus status;
  final String languageCode;
  final bool isDark;

  const VersionStatusCard({
    super.key,
    required this.status,
    required this.languageCode,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    switch (status) {
      case UpdateStatus.checking:
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.blue.withOpacity(0.15)
                : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.blue[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  AppLocalizationsHelper.translate(
                    'checkingForUpdate',
                    languageCode,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.blue[300]!
                        : Colors.blue[900]!,
                  ),
                ),
              ),
            ],
          ),
        );

      case UpdateStatus.upToDate:
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.green.withOpacity(0.3)
                  : Colors.green[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green[700],
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizationsHelper.translate(
                        'appIsUpToDate',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.green[300]!
                            : Colors.green[900]!,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizationsHelper.translate(
                        'youHaveLatestVersion',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.green[400]!
                            : Colors.green[700]!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case UpdateStatus.updateAvailable:
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.orange.withOpacity(0.15)
                : Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.orange[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.system_update_rounded,
                color: Colors.orange[700],
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizationsHelper.translate(
                        'updateAvailable',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.orange[300]!
                            : Colors.orange[900]!,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizationsHelper.translate(
                        'newVersionAvailable',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.orange[400]!
                            : Colors.orange[700]!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case UpdateStatus.error:
      case UpdateStatus.notSupported:
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDarkElevated
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : Colors.grey[700]!,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizationsHelper.translate(
                        'updateCheckNotAvailable',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : Colors.grey[900]!,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizationsHelper.translate(
                        isIOS
                            ? 'updateCheckNotAvailableMessageIOS'
                            : 'updateCheckNotAvailableMessage',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey[700]!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }
}

