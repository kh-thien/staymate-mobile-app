import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/maintenance.dart';
import '../providers/maintenance_request_provider.dart';

/// Page to display maintenance records (READ-ONLY for tenant)
/// Shows maintenance work progress from approved requests or owner-created tasks
class MaintenanceListPage extends ConsumerWidget {
  const MaintenanceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(maintenanceRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Công việc bảo trì'),
        backgroundColor: Colors.blue,
      ),
      body: maintenanceAsync.when(
        data: (maintenances) {
          if (maintenances.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có công việc bảo trì nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: maintenances.length,
            itemBuilder: (context, index) {
              final maintenance = maintenances[index];
              return _MaintenanceCard(maintenance: maintenance);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '❌ Lỗi: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: error.toString(),
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final Maintenance maintenance;

  const _MaintenanceCard({required this.maintenance});

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

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Chờ xử lý';
      case 'IN_PROGRESS':
        return 'Đang xử lý';
      case 'COMPLETED':
        return 'Hoàn thành';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    maintenance.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(maintenance.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getStatusText(maintenance.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Badge if from user's request
            if (maintenance.maintenanceRequestId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Từ báo cáo của bạn',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Description
            Text(
              maintenance.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Property and Room info
            Row(
              children: [
                Icon(Icons.home, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${maintenance.propertyName ?? "N/A"}${maintenance.roomName != null ? " - ${maintenance.roomName}" : ""}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Type and Priority
            Row(
              children: [
                Icon(Icons.build, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  maintenance.maintenanceType,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                if (maintenance.priority != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.flag, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    maintenance.priority!,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Cost if available
            if (maintenance.cost != null)
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(maintenance.cost)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

            const Divider(height: 24),

            // Timestamps
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tạo: ${dateFormat.format(maintenance.createdAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.update, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(maintenance.updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Read-only notice
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Chỉ xem - Bạn không thể chỉnh sửa công việc bảo trì',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
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
