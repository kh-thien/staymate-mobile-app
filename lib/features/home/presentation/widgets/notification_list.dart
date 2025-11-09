import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/notification_model.dart';
import '../providers/notifications_provider.dart';

/// Widget hiển thị danh sách thông báo gần đây
class NotificationList extends ConsumerWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(recentNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Chưa có thông báo nào',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        }

        return Column(
          children: notifications.map((notification) {
            return _NotificationItem(
              notification: notification,
              onTap: () {
                context.push('/notifications');
              },
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Lỗi: ${error.toString()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[700],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget hiển thị một thông báo
class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const _NotificationItem({
    required this.notification,
    this.onTap,
  });

  IconData _getIconByType(String type) {
    switch (type.toUpperCase()) {
      case 'BILL':
      case 'INVOICE':
        return Icons.receipt_long_rounded;
      case 'CONTRACT':
        return Icons.description_rounded;
      case 'MAINTENANCE':
      case 'REPORT':
        return Icons.report_problem_rounded;
      case 'PAYMENT':
        return Icons.payment_rounded;
      case 'CHAT':
      case 'MESSAGE':
        return Icons.chat_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getColorByType(String type) {
    switch (type.toUpperCase()) {
      case 'BILL':
      case 'INVOICE':
        return const Color(0xFF8B5CF6);
      case 'CONTRACT':
        return const Color(0xFFEC4899);
      case 'MAINTENANCE':
      case 'REPORT':
        return const Color(0xFFEF4444);
      case 'PAYMENT':
        return const Color(0xFF10B981);
      case 'CHAT':
      case 'MESSAGE':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final localTimestamp = timestamp.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localTimestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Vừa xong';
        }
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(localTimestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIconByType(notification.type);
    final color = _getColorByType(notification.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey[300]!
                : Colors.blue[400]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead
                          ? FontWeight.w600
                          : FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Message
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Timestamp
                  Text(
                    _formatTimestamp(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            // Unread indicator
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue[500],
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
