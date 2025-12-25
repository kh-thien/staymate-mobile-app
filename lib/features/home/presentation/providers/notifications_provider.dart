import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_model.dart';

part '../../../../generated/features/home/presentation/providers/notifications_provider.g.dart';

@riverpod
NotificationRemoteDatasource notificationRemoteDatasource(
  Ref ref,
) {
  return NotificationRemoteDatasource(Supabase.instance.client);
}

@riverpod
Future<List<NotificationModel>> recentNotifications(Ref ref) async {
  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  return await datasource.getRecentNotifications(limit: 5);
}

@riverpod
Future<List<NotificationModel>> allNotifications(Ref ref) async {
  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  return await datasource.getAllNotifications();
}

/// Stream provider for realtime notifications updates
@riverpod
Stream<List<NotificationModel>> allNotificationsStream(Ref ref) {
  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  return datasource.streamNotifications();
}

@riverpod
Stream<int> unreadNotificationsCount(Ref ref) {
  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  return datasource.streamNotifications().map(
    (notifications) =>
        notifications.where((notification) => !notification.isRead).length,
  );
}

@riverpod
Stream<List<NotificationModel>> recentNotificationsStream(Ref ref) {
  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  return datasource.streamNotifications().map(
    (notifications) => notifications.take(5).toList(),
  );
}

@riverpod
Future<void> markNotificationAsRead(
  Ref ref,
  String notificationId,
) async {
  // Check if provider is still mounted before async operation
  if (!ref.mounted) return;

  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  await datasource.markAsRead(notificationId);
  
  // Stream provider will automatically update via realtime subscription
  // No need to invalidate manually
}

