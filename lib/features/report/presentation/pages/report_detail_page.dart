import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận huỷ'),
        content: const Text('Bạn có chắc muốn huỷ báo cáo này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Huỷ báo cáo'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã huỷ báo cáo'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: const Text(
          'Bạn có chắc muốn xoá báo cáo này? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xoá'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã xoá báo cáo'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chi tiết sự cố',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: maintenanceRequestsAsync.when(
          data: (requests) {
            final request = requests.firstWhere(
              (r) => r.id == reportId,
              orElse: () => throw Exception('Không tìm thấy báo cáo'),
            );

            return [
              // Show cancel button if status is pending
              if (request.status == MaintenanceRequestStatus.pending)
                IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.black87,
                  ),
                  onPressed: () => _showCancelDialog(context, ref, request.id),
                  tooltip: 'Huỷ báo cáo',
                ),
              // Show delete button if status is cancelled
              if (request.status == MaintenanceRequestStatus.cancelled)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.black87),
                  onPressed: () => _showDeleteDialog(context, ref, request.id),
                  tooltip: 'Xoá báo cáo',
                ),
            ];
          },
          loading: () => [],
          error: (_, __) => [],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: maintenanceRequestsAsync.when(
          data: (requests) {
            final request = requests.firstWhere(
              (r) => r.id == reportId,
              orElse: () => throw Exception('Không tìm thấy báo cáo'),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  _StatusCard(request: request, theme: theme),
                  const SizedBox(height: 16),

                  // Property & Room Info
                  _InfoCard(
                    title: 'Thông tin vị trí',
                    icon: Icons.location_on_rounded,
                    children: [
                      _InfoRow(
                        label: 'Bất động sản',
                        value: request.propertyName ?? 'N/A',
                        icon: Icons.apartment_rounded,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'Phòng',
                        value: request.roomCode ?? request.roomName ?? 'N/A',
                        icon: Icons.meeting_room_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _InfoCard(
                    title: 'Mô tả sự cố',
                    icon: Icons.description_rounded,
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
                      title: 'Ảnh minh họa',
                      icon: Icons.image_rounded,
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
                                        'Không thể tải ảnh',
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
                    title: 'Thông tin thời gian',
                    icon: Icons.access_time_rounded,
                    children: [
                      _InfoRow(
                        label: 'Ngày báo cáo',
                        value: DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(request.createdAt),
                        icon: Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'Cập nhật lần cuối',
                        value: DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(request.updatedAt),
                        icon: Icons.update_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
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
                  'Lỗi: ${error.toString()}',
                  style: TextStyle(color: Colors.red.shade700),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final MaintenanceRequest request;
  final ThemeData theme;

  const _StatusCard({required this.request, required this.theme});

  @override
  Widget build(BuildContext context) {
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
                  'Trạng thái',
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

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
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

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
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
