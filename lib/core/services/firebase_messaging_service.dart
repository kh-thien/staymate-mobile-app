import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_mate/core/services/fcm_token_service.dart';

/// Top-level function để handle background messages
/// Phải là top-level function (không phải class method)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log(
    'Handling a background message: ${message.messageId}',
    name: 'FirebaseMessagingService',
  );
  developer.log('Message data: ${message.data}');
  developer.log('Message notification: ${message.notification?.title}');
}

class FirebaseMessagingService {
  FirebaseMessaging? _firebaseMessaging;
  FCMTokenService? _fcmTokenService;

  /// Lazy initialization của FCMTokenService để tránh circular dependency
  FCMTokenService get _tokenService {
    _fcmTokenService ??= FCMTokenService();
    return _fcmTokenService!;
  }

  FirebaseMessaging get firebaseMessaging {
    _firebaseMessaging ??= FirebaseMessaging.instance;
    return _firebaseMessaging!;
  }

  /// Khởi tạo Firebase Messaging
  Future<String?> initialize() async {
    try {
      // Đảm bảo Firebase đã được khởi tạo
      // FirebaseMessaging.instance sẽ tự động khởi tạo Firebase nếu chưa
      _firebaseMessaging = FirebaseMessaging.instance;

      // Request permission for notifications (Android 13+)
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      developer.log(
        'User granted permission: ${settings.authorizationStatus}',
        name: 'FirebaseMessagingService',
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        developer.log(
          'User granted notification permission',
          name: 'FirebaseMessagingService',
        );
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        developer.log(
          'User granted provisional notification permission',
          name: 'FirebaseMessagingService',
        );
      } else {
        developer.log(
          'User declined or has not accepted notification permission',
          name: 'FirebaseMessagingService',
        );
      }

      // Đăng ký background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Lấy FCM token
      String? token = await firebaseMessaging.getToken();
      developer.log(
        'FCM Token: $token',
        name: 'FirebaseMessagingService',
      );
      // In ra console để dễ thấy
      print('═══════════════════════════════════════════════════════');
      print('🔥 FCM TOKEN: $token');
      print('═══════════════════════════════════════════════════════');

      // Lắng nghe token refresh
      firebaseMessaging.onTokenRefresh.listen((newToken) {
        developer.log(
          'FCM Token refreshed: $newToken',
          name: 'FirebaseMessagingService',
        );
        _onTokenRefresh(newToken);
      });

      // Lưu token vào database nếu user đã đăng nhập
      if (token != null) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          await _tokenService.saveToken(user.id);
        }
      }

      // Xử lý foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Xử lý messages khi app được mở từ notification
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Kiểm tra xem app có được mở từ notification không (khi app terminated)
      RemoteMessage? initialMessage =
          await firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // Tạo notification channel cho Android
      await _createNotificationChannel();

      return token;
    } catch (e) {
      developer.log(
        'Error initializing Firebase Messaging: $e',
        name: 'FirebaseMessagingService',
        error: e,
      );
      return null;
    }
  }

  /// Tạo notification channel cho Android
  Future<void> _createNotificationChannel() async {
    // Notification channel được tạo tự động bởi firebase_messaging plugin
    // Chúng ta chỉ cần đảm bảo channel ID khớp với AndroidManifest.xml
  }

  /// Xử lý foreground messages (khi app đang mở)
  void _handleForegroundMessage(RemoteMessage message) {
    developer.log(
      'Got a message whilst in the foreground!',
      name: 'FirebaseMessagingService',
    );
    developer.log('Message data: ${message.data}');

    if (message.notification != null) {
      developer.log(
        'Message also contained a notification: ${message.notification}',
        name: 'FirebaseMessagingService',
      );
      // TODO: Hiển thị local notification hoặc update UI
    }
  }

  /// Xử lý khi user tap vào notification (app đã mở)
  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log(
      'Message opened app: ${message.messageId}',
      name: 'FirebaseMessagingService',
    );
    developer.log('Message data: ${message.data}');
    // TODO: Navigate to specific screen based on message data
  }

  /// Xử lý khi FCM token được refresh
  Future<void> _onTokenRefresh(String newToken) async {
    developer.log(
      'FCM Token refreshed: $newToken',
      name: 'FirebaseMessagingService',
    );
    // In ra console khi token được refresh
    print('═══════════════════════════════════════════════════════');
    print('🔄 FCM TOKEN REFRESHED: $newToken');
    print('═══════════════════════════════════════════════════════');

    // Cập nhật token trong database nếu user đã đăng nhập
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final oldToken = _tokenService.currentToken;
      if (oldToken != null) {
        await _tokenService.updateToken(user.id, oldToken, newToken);
      } else {
        await _tokenService.saveToken(user.id);
      }
    }
  }

  /// Lấy FCM token hiện tại
  Future<String?> getToken() async {
    try {
      return await firebaseMessaging.getToken();
    } catch (e) {
      developer.log(
        'Error getting FCM token: $e',
        name: 'FirebaseMessagingService',
        error: e,
      );
      return null;
    }
  }

  /// Xóa FCM token (khi user logout)
  Future<void> deleteToken() async {
    try {
      await firebaseMessaging.deleteToken();
      developer.log(
        'FCM Token deleted',
        name: 'FirebaseMessagingService',
      );
    } catch (e) {
      developer.log(
        'Error deleting FCM token: $e',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await firebaseMessaging.subscribeToTopic(topic);
      developer.log(
        'Subscribed to topic: $topic',
        name: 'FirebaseMessagingService',
      );
    } catch (e) {
      developer.log(
        'Error subscribing to topic: $e',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic(topic);
      developer.log(
        'Unsubscribed from topic: $topic',
        name: 'FirebaseMessagingService',
      );
    } catch (e) {
      developer.log(
        'Error unsubscribing from topic: $e',
        name: 'FirebaseMessagingService',
        error: e,
      );
    }
  }
}

