import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stay_mate/core/permission/permission_service.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/app_styles.dart';
import '../widgets/notification_hero_card.dart';
import '../widgets/notification_types_list.dart';
import '../widgets/settings_action_button.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends ConsumerState<NotificationSettingsPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  NotificationSettings? _notificationSettings;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _checkNotificationStatus();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkNotificationStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseMessaging = FirebaseMessaging.instance;
      final settings = await firebaseMessaging.getNotificationSettings();

      setState(() {
        _notificationSettings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final languageCode = ref.read(appLocaleProvider).languageCode;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('errorCheckingStatus', languageCode)}: $e',
            ),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseMessaging = FirebaseMessaging.instance;
      final settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      setState(() {
        _notificationSettings = settings;
        _isLoading = false;
      });

      if (mounted) {
        final languageCode = ref.read(appLocaleProvider).languageCode;
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizationsHelper.translate(
                      'notificationEnabledSuccess',
                      languageCode,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizationsHelper.translate(
                      'notificationPermissionDenied',
                      languageCode,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final languageCode = ref.read(appLocaleProvider).languageCode;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('errorRequestingPermission', languageCode)}: $e',
            ),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _openSystemSettings() async {
    final opened = await PermissionService.openSettings();
    if (!opened && mounted) {
      final languageCode = ref.read(appLocaleProvider).languageCode;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizationsHelper.translate(
              'cannotOpenSystemSettings',
              languageCode,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Refresh status after returning from settings
      Future.delayed(const Duration(seconds: 1), () {
        _checkNotificationStatus();
      });
    }
  }

  Future<void> _onToggleSwitch(bool value) async {
    if (_isLoading) return;

    if (value) {
      // User wants to enable notifications
      if (_isAuthorized()) {
        // Already authorized, do nothing
        return;
      } else if (_isDenied()) {
        // Permission denied, open settings
        await _openSystemSettings();
      } else {
        // Not determined, request permission
        await _requestNotificationPermission();
      }
    } else {
      // User wants to disable notifications
      // Can only disable in system settings
      await _openSystemSettings();
    }
  }


  bool _isAuthorized() {
    return _notificationSettings?.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  bool _isDenied() {
    return _notificationSettings?.authorizationStatus ==
        AuthorizationStatus.denied;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Use read instead of watch to avoid unnecessary rebuilds
    // Only rebuild when explicitly needed (e.g., language change)
    final languageCode = ref.read(appLocaleProvider).languageCode;

    return Scaffold(
      backgroundColor: isDark 
          ? AppColors.surfaceDark 
          : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark 
            ? AppColors.surfaceDarkElevated 
            : Colors.white,
        foregroundColor: isDark 
            ? AppColors.textPrimaryDark 
            : const Color(0xFF2D3748),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark 
                ? AppColors.textPrimaryDark 
                : const Color(0xFF2D3748),
          ),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          AppLocalizationsHelper.translate('notifications', languageCode),
          style: TextStyle(
            color: isDark 
                ? AppColors.textPrimaryDark 
                : const Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark 
                ? AppColors.dividerDark 
                : Colors.grey[200]!,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: _isLoading && _notificationSettings == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizationsHelper.translate(
                              'checkingNotificationStatus',
                              languageCode,
                            ),
                            style: TextStyle(
                              color: isDark 
                                  ? AppColors.textSecondaryDark 
                                  : Colors.grey[600]!,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hero Status Card
                            NotificationHeroCard(
                              notificationSettings: _notificationSettings,
                              isDark: isDark,
                              languageCode: languageCode,
                              isLoading: _isLoading,
                              onToggle: _onToggleSwitch,
                            ),
                            const SizedBox(height: 32),

                            // Notification Types Section
                            Text(
                              AppLocalizationsHelper.translate(
                                'notificationTypes',
                                languageCode,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark 
                                    ? AppColors.textPrimaryDark 
                                    : Colors.grey[900]!,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizationsHelper.translate(
                                'notificationTypesDescription',
                                languageCode,
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark 
                                    ? AppColors.textSecondaryDark 
                                    : Colors.grey[600]!,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            NotificationTypesList(
                              isDark: isDark,
                              languageCode: languageCode,
                            ),
                            const SizedBox(height: 32),

                            // Info Text
                            if (_isDenied() || !_isAuthorized())
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.orange.withOpacity(0.2)
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
                                      Icons.info_outline,
                                      color: isDark
                                          ? Colors.orange[300]!
                                          : Colors.orange[700]!,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _isDenied()
                                            ? AppLocalizationsHelper.translate(
                                                'notificationPermissionDeniedMessage',
                                                languageCode,
                                              )
                                            : AppLocalizationsHelper.translate(
                                                'notificationEnableMessage',
                                                languageCode,
                                              ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.orange[300]!
                                              : Colors.orange[900]!,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_isDenied())
                              const SizedBox(height: 16),
                            // Action Button for denied state
                            if (_isDenied())
                              SettingsActionButton(
                                icon: Icons.settings,
                                text: AppLocalizationsHelper.translate(
                                  'openSystemSettings',
                                  languageCode,
                                ),
                                onPressed: _openSystemSettings,
                                isLoading: _isLoading,
                                isDark: isDark,
                                languageCode: languageCode,
                              ),
                            if (_isAuthorized())
                              const SizedBox(height: 16),
                            if (_isAuthorized())
                              SettingsActionButton(
                                icon: Icons.tune_rounded,
                                text: AppLocalizationsHelper.translate(
                                  'manageInSettings',
                                  languageCode,
                                ),
                                onPressed: _openSystemSettings,
                                isLoading: _isLoading,
                                isDark: isDark,
                                languageCode: languageCode,
                                showArrow: true,
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

}
