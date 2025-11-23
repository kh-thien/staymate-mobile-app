import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class NotificationHeroCard extends StatelessWidget {
  final NotificationSettings? notificationSettings;
  final bool isDark;
  final String languageCode;
  final bool isLoading;
  final ValueChanged<bool>? onToggle;

  const NotificationHeroCard({
    super.key,
    required this.notificationSettings,
    required this.isDark,
    required this.languageCode,
    required this.isLoading,
    this.onToggle,
  });

  Color _getStatusColor() {
    if (notificationSettings == null) {
      return Colors.grey;
    }

    switch (notificationSettings!.authorizationStatus) {
      case AuthorizationStatus.authorized:
        return const Color(0xFF10B981); // Green
      case AuthorizationStatus.denied:
        return const Color(0xFFEF4444); // Red
      case AuthorizationStatus.notDetermined:
        return const Color(0xFFF59E0B); // Orange
      case AuthorizationStatus.provisional:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  IconData _getStatusIcon() {
    if (notificationSettings == null) {
      return Icons.help_outline;
    }

    switch (notificationSettings!.authorizationStatus) {
      case AuthorizationStatus.authorized:
        return Icons.notifications_active_rounded;
      case AuthorizationStatus.denied:
        return Icons.notifications_off_rounded;
      case AuthorizationStatus.notDetermined:
        return Icons.notifications_none_rounded;
      case AuthorizationStatus.provisional:
        return Icons.notifications_paused_rounded;
    }
  }

  bool _isAuthorized() {
    return notificationSettings?.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  bool _isDenied() {
    return notificationSettings?.authorizationStatus ==
        AuthorizationStatus.denied;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final isEnabled = _isAuthorized();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEnabled
              ? [
                  statusColor.withOpacity(0.1),
                  statusColor.withOpacity(0.05),
                ]
              : isDark
                  ? [
                      AppColors.surfaceDarkElevated.withOpacity(0.5),
                      AppColors.surfaceDarkElevated.withOpacity(0.3),
                    ]
                  : [
                      Colors.grey[200]!.withOpacity(0.5),
                      Colors.grey[100]!.withOpacity(0.3),
                    ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                size: 40,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 24),
            // Toggle Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizationsHelper.translate(
                          'notifications',
                          languageCode,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : Colors.grey[900]!,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isAuthorized()
                            ? AppLocalizationsHelper.translate(
                                'notificationEnabled',
                                languageCode,
                              )
                            : _isDenied()
                                ? AppLocalizationsHelper.translate(
                                    'notificationDisabled',
                                    languageCode,
                                  )
                                : AppLocalizationsHelper.translate(
                                    'notificationNotGranted',
                                    languageCode,
                                  ),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : Colors.grey[600]!,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // iOS Style Switch
                Transform.scale(
                  scale: 1.1,
                  child: CupertinoSwitch(
                    value: isEnabled,
                    onChanged: isLoading ? null : onToggle,
                    activeColor: const Color(0xFF34C759), // iOS Green
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

