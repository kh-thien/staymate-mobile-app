import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/maintenance.dart';
import '../../domain/entities/maintenance_request.dart';
import '../providers/maintenance_request_provider.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/providers/app_bar_provider.dart';

class ReportPage extends HookConsumerWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final theme = Theme.of(context);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    // Manage AppBar State
    useEffect(() {
      final notifier = ref.read(appBarProvider.notifier);
      // Use a small delay to ensure this runs after any cleanup from previous page
      Future.microtask(() {
        notifier.updateTitle(
          AppLocalizationsHelper.translate('reports', languageCode),
        );
      });
      // Don't reset in cleanup - let the next page set its own title
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Custom TabBar with modern design
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.primaryContainer,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: theme.colorScheme.onPrimaryContainer,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    tabs: [
                      Tab(
                        icon: const Icon(
                          Icons.report_problem_rounded,
                          size: 18,
                        ),
                        text: AppLocalizationsHelper.translate(
                          'reportIssue',
                          languageCode,
                        ),
                      ),
                      Tab(
                        icon: const Icon(Icons.construction_rounded, size: 18),
                        text: AppLocalizationsHelper.translate(
                          'maintenanceWork',
                          languageCode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // TabBarView content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    // Tab 1: Maintenance Requests
                    _MaintenanceRequestsTab(),
                    // Tab 2: Maintenance Records
                    _MaintenanceRecordsTab(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 80,
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            context.push('/report/create');
          },
          backgroundColor: const Color(0xFFEF4444),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.report_problem_rounded, size: 22),
          label: Text(
            AppLocalizationsHelper.translate('createReport', languageCode),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          elevation: 6,
          highlightElevation: 8,
        ),
      ),
    );
  }
}

// Tab 1: Maintenance Requests (existing)
class _MaintenanceRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceRequestsAsync = ref.watch(
      maintenanceRequestsStreamProvider,
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(maintenanceRequestsStreamProvider);
      },
      child: maintenanceRequestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            final languageCode = ref.watch(appLocaleProvider).languageCode;
            return EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: AppLocalizationsHelper.translate(
                'noIssuesToReport',
                languageCode,
              ),
              subtitle: AppLocalizationsHelper.translate(
                'yourReportedIssuesWillAppearHere',
                languageCode,
              ),
            );
          }
          final locale = ref.watch(appLocaleProvider);
          final languageCode = locale.languageCode;
          return _MaintenanceRequestsList(
            requests: requests,
            languageCode: languageCode,
          );
        },
        loading: () => ListView.separated(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 80,
          ),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return const MaintenanceRequestCardSkeleton();
          },
        ),
        error: (error, stack) {
          final locale = ref.watch(appLocaleProvider);
          final languageCode = locale.languageCode;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${AppLocalizationsHelper.translate('error', languageCode)}: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(maintenanceRequestsStreamProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      AppLocalizationsHelper.translate(
                        'tryAgain',
                        languageCode,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Tab 2: Maintenance Records (NEW - with REALTIME updates)
class _MaintenanceRecordsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Changed from maintenanceRecordsProvider to maintenanceRecordsStreamProvider
    final maintenanceAsync = ref.watch(maintenanceRecordsStreamProvider);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(maintenanceRecordsStreamProvider);
      },
      child: maintenanceAsync.when(
        data: (maintenances) {
          if (maintenances.isEmpty) {
            return EmptyState(
              icon: Icons.construction_rounded,
              title: AppLocalizationsHelper.translate(
                'noMaintenanceWork',
                languageCode,
              ),
              subtitle: AppLocalizationsHelper.translate(
                'maintenanceWorkWillShowHere',
                languageCode,
              ),
            );
          }
          return _MaintenanceList(
            maintenances: maintenances,
            languageCode: languageCode,
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: 4,
          itemBuilder: (context, index) {
            return const MaintenanceCardSkeleton();
          },
        ),
        error: (error, stack) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${AppLocalizationsHelper.translate('error', languageCode)}: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(maintenanceRecordsStreamProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      AppLocalizationsHelper.translate(
                        'tryAgain',
                        languageCode,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MaintenanceRequestsList extends ConsumerWidget {
  final List<MaintenanceRequest> requests;
  final String languageCode;

  const _MaintenanceRequestsList({
    required this.requests,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh will happen automatically via stream
      },
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          // a bit more top padding so the first card breathes
          top: 24,
          // ensure the last card is visible above bottom nav / FAB
          bottom: MediaQuery.of(context).padding.bottom + 80,
        ),
        itemCount: requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final request = requests[index];
          return _MaintenanceRequestCard(request: request);
        },
      ),
    );
  }
}

class _MaintenanceRequestCard extends ConsumerWidget {
  final MaintenanceRequest request;

  const _MaintenanceRequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade300,
          width: 2.0,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/report/${request.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.report_problem_rounded,
                        color: theme.colorScheme.error,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (request.propertyName != null)
                            Text(
                              request.propertyName!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (request.roomName != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.meeting_room_rounded,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    request.roomCode ?? request.roomName!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(
                      status: request.status,
                      languageCode: languageCode,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 12),

                // Footer info
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(request.createdAt, languageCode),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    if (request.urlReport != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizationsHelper.translate(
                                'hasImage',
                                languageCode,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date, String languageCode) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return AppLocalizationsHelper.translate('justNow', languageCode);
        }
        return AppLocalizationsHelper.translateWithParams(
          'minutesAgo',
          languageCode,
          {'minutes': difference.inMinutes.toString()},
        );
      }
      return AppLocalizationsHelper.translateWithParams(
        'hoursAgo',
        languageCode,
        {'hours': difference.inHours.toString()},
      );
    } else if (difference.inDays == 1) {
      return AppLocalizationsHelper.translate('yesterday', languageCode);
    } else if (difference.inDays < 7) {
      return AppLocalizationsHelper.translateWithParams(
        'daysAgo',
        languageCode,
        {'days': difference.inDays.toString()},
      );
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final MaintenanceRequestStatus status;
  final String languageCode;

  const _StatusBadge({required this.status, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case MaintenanceRequestStatus.pending:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        icon = Icons.schedule_rounded;
      case MaintenanceRequestStatus.approved:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        icon = Icons.check_circle_rounded;
      case MaintenanceRequestStatus.rejected:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.cancel_rounded;
      case MaintenanceRequestStatus.cancelled:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        icon = Icons.block_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppLocalizationsHelper.translate('pending', languageCode);
      case MaintenanceRequestStatus.approved:
        return AppLocalizationsHelper.translate('approved', languageCode);
      case MaintenanceRequestStatus.rejected:
        return AppLocalizationsHelper.translate('rejected', languageCode);
      case MaintenanceRequestStatus.cancelled:
        return AppLocalizationsHelper.translate('cancelled', languageCode);
    }
  }
}

// Empty state for Maintenance Records
// Maintenance List Widget
class _MaintenanceList extends StatelessWidget {
  final List<Maintenance> maintenances;
  final String languageCode;

  const _MaintenanceList({
    required this.maintenances,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: maintenances.length,
      itemBuilder: (context, index) {
        final isLastItem = index == maintenances.length - 1;
        return _MaintenanceCard(
          maintenance: maintenances[index],
          languageCode: languageCode,
          marginBottom: isLastItem ? 80.0 : 16.0,
        );
      },
    );
  }
}

// Maintenance Card Widget
class _MaintenanceCard extends StatelessWidget {
  final Maintenance maintenance;
  final String languageCode;
  final double marginBottom;

  const _MaintenanceCard({
    required this.maintenance,
    required this.languageCode,
    this.marginBottom = 16.0,
  });

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status, String languageCode) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppLocalizationsHelper.translate('waitingProcess', languageCode);
      case 'IN_PROGRESS':
        return AppLocalizationsHelper.translate('inProgress', languageCode);
      case 'COMPLETED':
        return AppLocalizationsHelper.translate('completed', languageCode);
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    maintenance.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : Colors.grey.shade900,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(maintenance.status),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(
                          maintenance.status,
                        ).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _getStatusText(maintenance.status, languageCode),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Badge if from user's request
            if (maintenance.maintenanceRequestId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade300, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizationsHelper.translate(
                        'fromYourReport',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                maintenance.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),

            // Property and Room info
            _InfoRow(
              icon: Icons.home_outlined,
              iconColor: Colors.purple,
              text:
                  '${maintenance.propertyName ?? "N/A"}${maintenance.roomName != null ? " - ${maintenance.roomName}" : ""}',
            ),
            const SizedBox(height: 10),

            // Type and Priority
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    icon: Icons.build_outlined,
                    iconColor: Colors.orange,
                    text: maintenance.maintenanceType,
                  ),
                ),
                if (maintenance.priority != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoRow(
                      icon: Icons.flag_outlined,
                      iconColor: Colors.red,
                      text: maintenance.priority!,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Cost if available
            if (maintenance.cost != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: 'đ',
                      ).format(maintenance.cost),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            const Divider(height: 28, thickness: 1),

            // Timestamps
            Row(
              children: [
                Expanded(
                  child: _TimestampChip(
                    icon: Icons.calendar_today_outlined,
                    label: AppLocalizationsHelper.translate(
                      'created',
                      languageCode,
                    ),
                    date: dateFormat.format(maintenance.createdAt),
                    languageCode: languageCode,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimestampChip(
                    icon: Icons.update_outlined,
                    label: AppLocalizationsHelper.translate(
                      'updated',
                      languageCode,
                    ),
                    date: dateFormat.format(maintenance.updatedAt),
                    languageCode: languageCode,
                  ),
                ),
              ],
            ),

            // Read-only notice
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizationsHelper.translate(
                        'viewOnlyCannotEdit',
                        languageCode,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade900,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for info rows
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Helper widget for timestamp chips
class _TimestampChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String date;
  final String languageCode;

  const _TimestampChip({
    required this.icon,
    required this.label,
    required this.date,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blueGrey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blueGrey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
