import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/logo_app.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/version_status_card.dart' show UpdateStatus, VersionStatusCard;
import '../widgets/legal_link_widget.dart';

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final updateStatus = useState<UpdateStatus>(UpdateStatus.checking);
    final packageInfoFuture = useMemoized(() => PackageInfo.fromPlatform());

    // Check update status when page loads
    useEffect(() {
      _checkUpdateStatus(context, ref, updateStatus);
      return null;
    }, []);

    return Scaffold(
      backgroundColor: isDark 
          ? AppColors.surfaceDark 
          : Colors.white,
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
          AppLocalizationsHelper.translate('appInfo', languageCode),
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
      body: FutureBuilder<PackageInfo>(
        future: packageInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizationsHelper.translate('error', languageCode),
              ),
            );
          }

          final packageInfo = snapshot.data!;
          final currentVersion = '${packageInfo.version} (${packageInfo.buildNumber})';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                        isDark ? LogoApp.logoIconPngDark : LogoApp.logoIconPng,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Nếu logo không load được, dùng icon với màu primary
                          return Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.home_rounded,
                              size: 60,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.primary,
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
                const SizedBox(height: 40),

                // Version Status Card - Dynamic based on update status
                VersionStatusCard(
                  status: updateStatus.value,
                  languageCode: languageCode,
                  isDark: isDark,
                ),

                const SizedBox(height: 24),

                // Check Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: updateStatus.value == UpdateStatus.checking
                        ? null
                        : () => _checkForUpdate(context, ref, updateStatus),
                    icon: updateStatus.value == UpdateStatus.checking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.system_update_rounded),
                    label: Text(
                      updateStatus.value == UpdateStatus.checking
                          ? AppLocalizationsHelper.translate(
                              'checkingForUpdate',
                              languageCode,
                            )
                          : AppLocalizationsHelper.translate(
                              'checkForUpdate',
                              languageCode,
                            ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Legal Links Section
                Container(
                  padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark 
                ? AppColors.surfaceDarkElevated 
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark 
                  ? AppColors.borderDark 
                  : Colors.grey[300]!,
            ),
          ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizationsHelper.translate(
                          'additionalInfo',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark 
                            ? AppColors.textPrimaryDark 
                              : Colors.black87,
                      ),
                    ),
                      const SizedBox(height: 16),
                      LegalLinkWidget(
                        icon: Icons.privacy_tip_outlined,
                        title: AppLocalizationsHelper.translate(
                          'privacyPolicy',
                        languageCode,
                      ),
                        url: AppConstants.privacyPolicyUrl,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      LegalLinkWidget(
                        icon: Icons.description_outlined,
                        title: AppLocalizationsHelper.translate(
                          'termsOfService',
                          languageCode,
                        ),
                        url: AppConstants.termsOfServiceUrl,
                        isDark: isDark,
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
        },
      ),
    );
  }


  Future<void> _checkUpdateStatus(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<UpdateStatus> updateStatus,
  ) async {
    if (!Platform.isAndroid) {
      updateStatus.value = UpdateStatus.notSupported;
      return;
    }

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        updateStatus.value = UpdateStatus.updateAvailable;
      } else {
        updateStatus.value = UpdateStatus.upToDate;
      }
    } catch (e) {
      // Handle ERROR_APP_NOT_OWNED and other errors
      if (e.toString().contains('ERROR_APP_NOT_OWNED') ||
          e.toString().contains('MissingPluginException')) {
        updateStatus.value = UpdateStatus.notSupported;
      } else {
        updateStatus.value = UpdateStatus.error;
      }
    }
  }

  Future<void> _checkForUpdate(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<UpdateStatus> updateStatus,
  ) async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;

    updateStatus.value = UpdateStatus.checking;

    try {
      // Check for update availability
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (!context.mounted) return;

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        updateStatus.value = UpdateStatus.updateAvailable;
        
        // Show update dialog
        if (updateInfo.immediateUpdateAllowed) {
          // Start immediate update
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Start flexible update
          await InAppUpdate.startFlexibleUpdate();
          // Complete the update when ready
          await InAppUpdate.completeFlexibleUpdate();
        } else {
          // Show dialog to redirect to Play Store
          _showUpdateDialog(context, ref, languageCode);
        }
      } else {
        updateStatus.value = UpdateStatus.upToDate;
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizationsHelper.translate(
                  'noUpdateAvailable',
                  languageCode,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;

      // Handle specific errors
      if (e.toString().contains('ERROR_APP_NOT_OWNED') ||
          e.toString().contains('MissingPluginException')) {
        updateStatus.value = UpdateStatus.notSupported;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizationsHelper.translate(
                Platform.isIOS
                    ? 'updateCheckNotAvailableMessageIOS'
                    : 'updateCheckNotAvailableMessage',
                languageCode,
              ),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        updateStatus.value = UpdateStatus.error;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('error', languageCode)}: ${e.toString().split(':').first}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showUpdateDialog(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizationsHelper.translate('updateAvailable', languageCode),
        ),
        content: Text(
          AppLocalizationsHelper.translate(
            'updateAvailableMessage',
            languageCode,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizationsHelper.translate('later', languageCode),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _openPlayStore(context, ref);
            },
            child: Text(
              AppLocalizationsHelper.translate('update', languageCode),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPlayStore(BuildContext context, WidgetRef ref) async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      
      String url;
      if (Platform.isAndroid) {
        url = 'https://play.google.com/store/apps/details?id=$packageName';
      } else if (Platform.isIOS) {
        url = 'https://apps.apple.com/app/id$packageName';
      } else {
        return;
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizationsHelper.translate('error', languageCode),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('error', languageCode)}: $e',
            ),
          ),
        );
      }
    }
  }
}

