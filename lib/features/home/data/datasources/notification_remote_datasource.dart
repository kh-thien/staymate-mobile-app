import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationRemoteDatasource {
  final SupabaseClient _supabase;

  NotificationRemoteDatasource(this._supabase);

  /// Get recent notifications for current user (limit 5)
  Future<List<NotificationModel>> getRecentNotifications({
    int limit = 5,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  /// Get all notifications for current user
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId)
          .eq('user_id', user.id)
          .select();

      if (response.isEmpty) {
        throw Exception('Failed to mark notification as read: No rows updated');
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Stream notifications for realtime updates
  Stream<List<NotificationModel>> streamNotifications() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    return _supabase
        .from('notifications')
        .stream(
          primaryKey: ['id'],
        )
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .map(
          (rows) => rows
              .map(
                (json) => NotificationModel.fromJson(json),
              )
              .toList(),
        );
  }
}

