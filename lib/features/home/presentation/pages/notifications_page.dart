import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/notification_model.dart';
import '../providers/notifications_provider.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    // Use stream provider for realtime updates
    final notificationsAsync = ref.watch(allNotificationsStreamProvider);

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
          AppLocalizationsHelper.translate('notifications', languageCode),
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
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizationsHelper.translate('noNotificationsYet', languageCode),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Invalidate stream to trigger reload
              ref.invalidate(allNotificationsStreamProvider);
              // Wait a bit for stream to emit new data
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  notification: notification,
                  languageCode: languageCode,
                  onTap: () => _handleNotificationTap(
                    context,
                    ref,
                    notification,
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${AppLocalizationsHelper.translate('error', languageCode)}: ${error.toString()}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(allNotificationsStreamProvider);
                    },
                    child: Text(AppLocalizationsHelper.translate('tryAgain', languageCode)),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) async {
    // Mark as read if not already read
    if (!notification.isRead) {
      try {
        await ref.read(
          markNotificationAsReadProvider(notification.id).future,
        );
      } catch (e) {
        // Handle error silently or show snackbar
        if (context.mounted) {
          final locale = ref.read(appLocaleProvider);
          final languageCode = locale.languageCode;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppLocalizationsHelper.translate('error', languageCode)}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // Navigate based on actionUrl only
    if (!context.mounted) return;

    // If no actionUrl, do nothing
    if (notification.actionUrl == null || notification.actionUrl!.isEmpty) {
      return;
    }

    final router = GoRouter.of(context);
    final currentLocation = router.routerDelegate.currentConfiguration.uri.path;

    try {
      final url = notification.actionUrl!;
      String targetRoute;

      // Parse /bills/ to /invoice/
      if (url.startsWith('/bills/')) {
        final billId = url.replaceFirst('/bills/', '');
        targetRoute = '/invoice/$billId';
      } else if (url.startsWith('/')) {
        targetRoute = url;
      } else {
        // Invalid URL format, do nothing
        return;
      }

      // Only navigate if target route is different from current location
      if (targetRoute != currentLocation) {
        // Use go instead of push to avoid duplicate keys
        context.go(targetRoute);
      }
    } catch (e) {
      // Handle navigation errors
      if (context.mounted) {
        final locale = ref.read(appLocaleProvider);
        final languageCode = locale.languageCode;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizationsHelper.translate('cannotNavigate', languageCode)}: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final String languageCode;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.languageCode,
    required this.onTap,
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
      return DateFormat('dd/MM/yyyy').format(localTimestamp);
    }
  }

  String _translateNotificationContent(String content, String type) {
    // Nếu đang ở tiếng Việt, trả về nguyên bản
    if (languageCode == 'vi') {
      return content;
    }

    // Translate dựa trên type và một số pattern matching
    final lowerContent = content.toLowerCase();
    final lowerType = type.toLowerCase();

    // Pattern matching cho các loại notification phổ biến
    if (lowerType.contains('invoice') || lowerType.contains('bill')) {
      if (lowerContent.contains('hóa đơn mới')) {
        return 'New invoice';
      }
      if (lowerContent.contains('hóa đơn')) {
        return content.replaceAll('hóa đơn', 'invoice');
      }
    }

    if (lowerType.contains('contract')) {
      if (lowerContent.contains('hợp đồng mới')) {
        return 'New contract';
      }
      if (lowerContent.contains('hợp đồng')) {
        return content.replaceAll('hợp đồng', 'contract');
      }
    }

    if (lowerType.contains('payment')) {
      if (lowerContent.contains('thanh toán')) {
        return content.replaceAll('thanh toán', 'payment');
      }
    }

    if (lowerType.contains('maintenance') || lowerType.contains('report')) {
      if (lowerContent.contains('báo cáo')) {
        return content.replaceAll('báo cáo', 'report');
      }
      if (lowerContent.contains('bảo trì')) {
        return content.replaceAll('bảo trì', 'maintenance');
      }
    }

    // Nếu không match được, trả về nguyên bản
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIconByType(notification.type);
    final color = _getColorByType(notification.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey[300]!
                : const Color(0xFF3B82F6),
            width: notification.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
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
                    _translateNotificationContent(
                      notification.title,
                      notification.type,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead
                          ? FontWeight.w600
                          : FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Message
                  Text(
                    _translateNotificationContent(
                      notification.message,
                      notification.type,
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
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
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

