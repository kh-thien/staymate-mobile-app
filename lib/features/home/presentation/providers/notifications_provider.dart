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

@riverpod
Future<void> markNotificationAsRead(
  Ref ref,
  String notificationId,
) async {
  // Check if provider is still mounted before async operation
  if (!ref.mounted) return;

  final datasource = ref.watch(notificationRemoteDatasourceProvider);
  await datasource.markAsRead(notificationId);
  
  // Check mounted again after async operation before invalidating
  if (ref.mounted) {
    ref.invalidate(allNotificationsProvider);
    ref.invalidate(recentNotificationsProvider);
  }
}

