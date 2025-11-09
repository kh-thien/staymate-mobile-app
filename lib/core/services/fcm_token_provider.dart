import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_messaging_service.dart';

/// Provider cho FirebaseMessagingService instance
final firebaseMessagingServiceProvider =
    Provider<FirebaseMessagingService>((ref) {
  return FirebaseMessagingService();
});

/// Provider để lấy FCM token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(firebaseMessagingServiceProvider);
  return await service.getToken();
});

