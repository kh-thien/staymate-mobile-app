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

enum UpdateStatus {
  checking,
  upToDate,
  updateAvailable,
  error,
  notSupported,
}

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          AppLocalizationsHelper.translate('appInfo', languageCode),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
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
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Version Status Card - Dynamic based on update status
                _buildVersionStatusCard(
                  context,
                  ref,
                  languageCode,
                  updateStatus.value,
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

              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVersionStatusCard(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
    UpdateStatus status,
  ) {
    switch (status) {
      case UpdateStatus.checking:
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue[200]!,
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
                    color: Colors.blue[900],
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
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green[200]!,
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
                        color: Colors.green[900],
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
                        color: Colors.green[700],
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
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange[200]!,
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
                        color: Colors.orange[900],
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
                        color: Colors.orange[700],
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
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.grey[700],
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
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizationsHelper.translate(
                        'updateCheckNotAvailableMessage',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
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
                'updateCheckNotAvailableMessage',
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

