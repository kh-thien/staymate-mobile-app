import 'package:flutter/foundation.dart';

/// Logger utility for chat feature
/// Set kDebugMode to false in production to disable logs
class ChatLogger {
  /// Log general info (can be disabled in production)
  static void info(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Log errors (always enabled, important for debugging)
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    // Always log errors, even in production
    print('❌ $message');
    if (error != null) print('   Error: $error');
    if (stackTrace != null && kDebugMode) {
      print('   Stack: $stackTrace');
    }
  }

  /// Log notifications (KEEP for push notification implementation)
  static void notification(String message) {
    // Always log notifications for push notification tracking
    print('🔔 $message');
  }

  /// Log success (can be disabled in production)
  static void success(String message) {
    if (kDebugMode) {
      print('✅ $message');
    }
  }
}
