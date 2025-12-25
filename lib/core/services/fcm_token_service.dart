import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as developer;

class FCMTokenService {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? _currentToken;

  /// Lấy FCM token từ Firebase Messaging
  Future<String?> _getFCMToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      developer.log(
        'Error getting FCM token: $e',
        name: 'FCMTokenService',
        error: e,
      );
      return null;
    }
  }

  /// Lưu FCM token khi user đăng nhập
  Future<void> saveToken(String userId) async {
    try {
      final token = await _getFCMToken();
      if (token == null) {
        developer.log(
          'No FCM token available',
          name: 'FCMTokenService',
        );
        return;
      }

      _currentToken = token;

      final platform = Platform.isIOS
          ? 'ios'
          : (Platform.isAndroid ? 'android' : 'web');

      // Lấy thông tin device
      String? deviceId;
      String? deviceName;
      String? appVersion;

      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor;
          deviceName = '${iosInfo.name} (${iosInfo.model})';
          developer.log(
            'iOS Device Info - ID: $deviceId, Name: $deviceName',
            name: 'FCMTokenService',
          );
        } else if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceId = androidInfo.id;
          deviceName = '${androidInfo.brand} ${androidInfo.model}';
          developer.log(
            'Android Device Info - ID: $deviceId, Name: $deviceName',
            name: 'FCMTokenService',
          );
        }

        final packageInfo = await PackageInfo.fromPlatform();
        appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        developer.log(
          'App Version: $appVersion',
          name: 'FCMTokenService',
        );
      } catch (e) {
        developer.log(
          'Error getting device info: $e',
          name: 'FCMTokenService',
          error: e,
        );
        // Tiếp tục với device info là null nếu có lỗi
      }

      // Kiểm tra xem token đã tồn tại chưa
      final existingToken = await _supabase
          .from('user_device_tokens')
          .select('id, user_id')
          .eq('fcm_token', token)
          .maybeSingle();

      if (existingToken != null) {
        // Token đã tồn tại - update nếu là của user này
        if (existingToken['user_id'] == userId) {
          await _supabase
              .from('user_device_tokens')
              .update({
                'user_id': userId,
                'device_id': deviceId,
                'device_name': deviceName,
                'platform': platform,
                'app_version': appVersion,
                'is_active': true,
                'last_used_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('fcm_token', token);
        } else {
          // Token thuộc user khác - tạo record mới (sẽ fail vì unique constraint)
          // Trong trường hợp này, xóa token cũ và tạo mới
          await _supabase
              .from('user_device_tokens')
              .delete()
              .eq('fcm_token', token);
          
          await _supabase.from('user_device_tokens').insert({
            'user_id': userId,
            'fcm_token': token,
            'device_id': deviceId,
            'device_name': deviceName,
            'platform': platform,
            'app_version': appVersion,
            'is_active': true,
            'last_used_at': DateTime.now().toIso8601String(),
          });
        }
      } else {
        // Token chưa tồn tại - insert mới
        await _supabase.from('user_device_tokens').insert({
          'user_id': userId,
          'fcm_token': token,
          'device_id': deviceId,
          'device_name': deviceName,
          'platform': platform,
          'app_version': appVersion,
          'is_active': true,
          'last_used_at': DateTime.now().toIso8601String(),
        });
      }

      developer.log(
        '✅ FCM token saved: $token',
        name: 'FCMTokenService',
      );
      print('═══════════════════════════════════════════════════════');
      print('💾 FCM TOKEN SAVED TO DATABASE: $token');
      print('═══════════════════════════════════════════════════════');
    } catch (e) {
      developer.log(
        '❌ Error saving FCM token: $e',
        name: 'FCMTokenService',
        error: e,
      );
    }
  }

  /// Xóa FCM token khi user đăng xuất
  Future<void> deleteToken(String userId) async {
    try {
      final token = await _getFCMToken();
      if (token == null) {
        developer.log(
          'No FCM token available to delete',
          name: 'FCMTokenService',
        );
        return;
      }

      // Xóa token khỏi database
      await _supabase
          .from('user_device_tokens')
          .delete()
          .eq('user_id', userId)
          .eq('fcm_token', token);

      developer.log(
        '✅ FCM token deleted from database: $token',
        name: 'FCMTokenService',
      );

      // Xóa token từ Firebase (optional - có thể giữ lại để nhận notification sau khi logout)
      // await _fcmService.deleteToken();

      _currentToken = null;

      print('═══════════════════════════════════════════════════════');
      print('🗑️ FCM TOKEN DELETED FROM DATABASE: $token');
      print('═══════════════════════════════════════════════════════');
    } catch (e) {
      developer.log(
        '❌ Error deleting FCM token: $e',
        name: 'FCMTokenService',
        error: e,
      );
    }
  }

  /// Cập nhật token khi refresh
  Future<void> updateToken(String userId, String oldToken, String newToken) async {
    try {
      // Update token trong database
      await _supabase
          .from('user_device_tokens')
          .update({
            'fcm_token': newToken,
            'updated_at': DateTime.now().toIso8601String(),
            'last_used_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('fcm_token', oldToken);

      _currentToken = newToken;

      developer.log(
        '✅ FCM token updated: $oldToken -> $newToken',
        name: 'FCMTokenService',
      );
      print('═══════════════════════════════════════════════════════');
      print('🔄 FCM TOKEN UPDATED IN DATABASE: $oldToken -> $newToken');
      print('═══════════════════════════════════════════════════════');
    } catch (e) {
      developer.log(
        '❌ Error updating FCM token: $e',
        name: 'FCMTokenService',
        error: e,
      );
      
      // Nếu update thất bại, thử insert token mới
      try {
        await saveToken(userId);
      } catch (insertError) {
        developer.log(
          '❌ Error inserting new token: $insertError',
          name: 'FCMTokenService',
          error: insertError,
        );
      }
    }
  }

  /// Lấy tất cả token của user (cho server/testing)
  Future<List<String>> getUserTokens(String userId) async {
    try {
      final response = await _supabase
          .from('user_device_tokens')
          .select('fcm_token')
          .eq('user_id', userId)
          .eq('is_active', true);

      return (response as List)
          .map((e) => e['fcm_token'] as String)
          .toList();
    } catch (e) {
      developer.log(
        '❌ Error getting user tokens: $e',
        name: 'FCMTokenService',
        error: e,
      );
      return [];
    }
  }

  /// Lấy token hiện tại
  String? get currentToken => _currentToken;

  /// Đánh dấu token không active (thay vì xóa)
  Future<void> deactivateToken(String userId, String token) async {
    try {
      await _supabase
          .from('user_device_tokens')
          .update({'is_active': false})
          .eq('user_id', userId)
          .eq('fcm_token', token);

      developer.log(
        '✅ FCM token deactivated: $token',
        name: 'FCMTokenService',
      );
    } catch (e) {
      developer.log(
        '❌ Error deactivating FCM token: $e',
        name: 'FCMTokenService',
        error: e,
      );
    }
  }
}

