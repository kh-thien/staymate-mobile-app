class AppConstants {
  // API
  static const String baseUrl = 'https://api.staymate.com';
  static const String apiVersion = '/v1';

  // App Info
  static const String appName = 'StayMate';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userProfile = 'user_profile';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
