import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/app_styles.dart';
import '../../domain/entities/maintenance_request.dart';
import '../providers/maintenance_request_provider.dart';

class ReportDetailPage extends ConsumerWidget {
  final String reportId;

  const ReportDetailPage({super.key, required this.reportId});

  Future<void> _showCancelDialog(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizationsHelper.translate('confirmCancel', languageCode),
        ),
        content: Text(
          AppLocalizationsHelper.translate('confirmCancelReport', languageCode),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizationsHelper.translate('no', languageCode),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              AppLocalizationsHelper.translate('cancelReport', languageCode),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(cancelMaintenanceRequestProvider(id).future);
        if (context.mounted) {
          // Navigate back first
          context.pop();

          // Show snackbar after navigation
          await Future.delayed(const Duration(milliseconds: 100));
          if (context.mounted) {
            final locale = ref.read(appLocaleProvider);
            final languageCode = locale.languageCode;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizationsHelper.translate(
                    'reportCancelled',
                    languageCode,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          final locale = ref.read(appLocaleProvider);
          final languageCode = locale.languageCode;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizationsHelper.translate('error', languageCode)}: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizationsHelper.translate('confirmDelete', languageCode),
        ),
        content: Text(
          AppLocalizationsHelper.translate(
            'confirmDeleteReport',
            languageCode,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizationsHelper.translate('no', languageCode),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              AppLocalizationsHelper.translate('delete', languageCode),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(deleteMaintenanceRequestProvider(id).future);
        if (context.mounted) {
          // Navigate back first
          context.pop();

          // Show snackbar after navigation
          await Future.delayed(const Duration(milliseconds: 100));
          if (context.mounted) {
            final locale = ref.read(appLocaleProvider);
            final languageCode = locale.languageCode;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizationsHelper.translate(
                    'reportDeleted',
                    languageCode,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          final locale = ref.read(appLocaleProvider);
          final languageCode = locale.languageCode;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizationsHelper.translate('error', languageCode)}: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final maintenanceRequestsAsync = ref.watch(
      maintenanceRequestsStreamProvider,
    );

    final isDark = theme.brightness == Brightness.dark;

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
            : Colors.black87,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark 
                ? AppColors.textPrimaryDark 
                : Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: Builder(
          builder: (context) {
            final locale = ref.watch(appLocaleProvider);
            final languageCode = locale.languageCode;
            return Text(
              AppLocalizationsHelper.translate('reportDetail', languageCode),
              style: TextStyle(
                color: isDark 
                    ? AppColors.textPrimaryDark 
                    : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: maintenanceRequestsAsync.when(
          data: (requests) {
            final locale = ref.read(appLocaleProvider);
            final languageCode = locale.languageCode;
            final request = requests.firstWhere(
              (r) => r.id == reportId,
              orElse: () => throw Exception(
                AppLocalizationsHelper.translate(
                  'reportNotFound',
                  languageCode,
                ),
              ),
            );

            return [
              // Show cancel button if status is pending
              if (request.status == MaintenanceRequestStatus.pending)
                IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: isDark 
                        ? AppColors.textPrimaryDark 
                        : Colors.black87,
                  ),
                  onPressed: () => _showCancelDialog(context, ref, request.id),
                  tooltip: AppLocalizationsHelper.translate(
                    'cancelReport',
                    languageCode,
                  ),
                ),
              // Show delete button if status is cancelled
              if (request.status == MaintenanceRequestStatus.cancelled)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline, 
                    color: isDark 
                        ? AppColors.textPrimaryDark 
                        : Colors.black87,
                  ),
                  onPressed: () => _showDeleteDialog(context, ref, request.id),
                  tooltip: AppLocalizationsHelper.translate(
                    'deleteReport',
                    languageCode,
                  ),
                ),
            ];
          },
          loading: () => [],
          error: (_, __) => [],
        ),
      ),
      body: Container(
        color: isDark 
            ? AppColors.surfaceDark 
            : Colors.white,
        child: maintenanceRequestsAsync.when(
          data: (requests) {
            final locale = ref.read(appLocaleProvider);
            final languageCode = locale.languageCode;
            final request = requests.firstWhere(
              (r) => r.id == reportId,
              orElse: () => throw Exception(
                AppLocalizationsHelper.translate(
                  'reportNotFound',
                  languageCode,
                ),
              ),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  _StatusCard(
                    request: request,
                    theme: theme,
                    languageCode: languageCode,
                  ),
                  const SizedBox(height: 16),

                  // Property & Room Info
                  _InfoCard(
                    title: AppLocalizationsHelper.translate(
                      'locationInfo',
                      languageCode,
                    ),
                    icon: Icons.location_on_rounded,
                    languageCode: languageCode,
                    children: [
                      _InfoRow(
                        label: AppLocalizationsHelper.translate(
                          'property',
                          languageCode,
                        ),
                        value: request.propertyName ?? 'N/A',
                        icon: Icons.apartment_rounded,
                        languageCode: languageCode,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: AppLocalizationsHelper.translate(
                          'room',
                          languageCode,
                        ),
                        value: request.roomCode ?? request.roomName ?? 'N/A',
                        icon: Icons.meeting_room_rounded,
                        languageCode: languageCode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _InfoCard(
                    title: AppLocalizationsHelper.translate(
                      'issueDescription',
                      languageCode,
                    ),
                    icon: Icons.description_rounded,
                    languageCode: languageCode,
                    children: [
                      Text(
                        request.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Image if available
                  if (request.urlReport != null) ...[
                    _InfoCard(
                      title: AppLocalizationsHelper.translate(
                        'illustrationImage',
                        languageCode,
                      ),
                      icon: Icons.image_rounded,
                      languageCode: languageCode,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            request.urlReport!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image_rounded,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizationsHelper.translate(
                                          'cannotLoadImage',
                                          languageCode,
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Timeline
                  _InfoCard(
                    title: AppLocalizationsHelper.translate(
                      'timeInfo',
                      languageCode,
                    ),
                    icon: Icons.access_time_rounded,
                    languageCode: languageCode,
                    children: [
                      _InfoRow(
                        label: AppLocalizationsHelper.translate(
                          'reportDate',
                          languageCode,
                        ),
                        value: DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(request.createdAt),
                        icon: Icons.calendar_today_rounded,
                        languageCode: languageCode,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: AppLocalizationsHelper.translate(
                          'lastUpdated',
                          languageCode,
                        ),
                        value: DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(request.updatedAt),
                        icon: Icons.update_rounded,
                        languageCode: languageCode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            final locale = ref.read(appLocaleProvider);
            final languageCode = locale.languageCode;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${AppLocalizationsHelper.translate('error', languageCode)}: ${error.toString()}',
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusCard extends ConsumerWidget {
  final MaintenanceRequest request;
  final ThemeData theme;
  final String languageCode;

  const _StatusCard({
    required this.request,
    required this.theme,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color statusColor;
    IconData statusIcon;

    switch (request.status) {
      case MaintenanceRequestStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule_rounded;
        break;
      case MaintenanceRequestStatus.approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case MaintenanceRequestStatus.rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
      case MaintenanceRequestStatus.cancelled:
        statusColor = Colors.grey;
        statusIcon = Icons.block_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizationsHelper.translate('status', languageCode),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.statusText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
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

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final String languageCode;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String languageCode;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
