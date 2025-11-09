import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stay_mate/core/services/fcm_token_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FCMTokenService _fcmTokenService = FCMTokenService();

  /// Web Client ID that you registered with Google Cloud.
  final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
     
  /// iOS Client ID that you registered with Google Cloud.
  final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID']!;
      

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.

  // Kiểm tra trạng thái đăng nhập
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Lấy thông tin user hiện tại
  User? get currentUser => _supabase.auth.currentUser;

  /// Kiểm tra role của user từ bảng users
  /// Trả về role của user hoặc null nếu không tìm thấy
  Future<String?> getUserRole(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('userid', userId)
          .maybeSingle();

      return response?['role'] as String?;
    } catch (e) {
      // Nếu có lỗi, trả về null (cho phép đăng nhập)
      return null;
    }
  }

  /// Kiểm tra và block admin users
  /// Nếu user là ADMIN, đăng xuất và throw exception
  Future<void> checkAndBlockAdmin(String userId) async {
    final role = await getUserRole(userId);
    
    if (role == 'ADMIN') {
      // Xóa FCM token trước khi đăng xuất
      try {
        await _fcmTokenService.deleteToken(userId);
      } catch (e) {
        // Ignore error khi xóa FCM token
      }
      
      // Đăng xuất user (skip FCM token deletion vì đã xóa ở trên)
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
      await _supabase.auth.signOut();
      
      throw AuthException(
        'Ứng dụng này dành riêng cho người thuê, tính năng admin sẽ được phát triển sau',
        statusCode: 'admin_blocked',
      );
    }
  }

  // Đăng nhập bằng email/password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Kiểm tra email đã được xác nhận chưa
      if (response.user != null) {
        // Nếu email chưa được xác nhận, throw exception
        if (response.user!.emailConfirmedAt == null) {
          throw AuthException(
            'Email chưa được xác nhận. Vui lòng kiểm tra hộp thư và xác nhận email trước khi đăng nhập.',
            statusCode: 'email_not_confirmed',
          );
        }

        // Kiểm tra role và block admin
        await checkAndBlockAdmin(response.user!.id);
        
        // Lưu FCM token sau khi đăng nhập thành công (chỉ khi không phải admin)
        await _fcmTokenService.saveToken(response.user!.id);
      }

      return response;
    } on AuthException {
      // Re-throw AuthException để bloc có thể xử lý
      rethrow;
    } catch (e) {
      // Wrap các lỗi khác thành AuthException
      throw AuthException(
        e.toString(),
        statusCode: 'unknown_error',
      );
    }
  }

  // Đăng ký bằng email/password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      // Kiểm tra role và block admin (chỉ khi user đã có session)
      if (response.user != null && response.session != null) {
        await checkAndBlockAdmin(response.user!.id);
        
        // Lưu FCM token sau khi đăng ký thành công (chỉ khi đã có session)
        await _fcmTokenService.saveToken(response.user!.id);
      }
      // Nếu response.session == null, có nghĩa là email confirmation required
      // Không cần block admin hoặc lưu FCM token trong trường hợp này

      return response;
    } on AuthException {
      // Re-throw AuthException để bloc có thể xử lý
      rethrow;
    } catch (e) {
      // Wrap các lỗi khác thành AuthException
      throw AuthException(
        e.toString(),
        statusCode: 'unknown_error',
      );
    }
  }

  // Đăng nhập bằng Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Initialize with client IDs
      await googleSignIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw AuthException(
          'Không thể lấy ID Token từ Google. Vui lòng thử lại.',
          statusCode: 'google_signin_failed',
        );
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      // Kiểm tra role và block admin
      if (response.user != null) {
        await checkAndBlockAdmin(response.user!.id);
        
        // Lưu FCM token sau khi đăng nhập thành công (chỉ khi không phải admin)
        await _fcmTokenService.saveToken(response.user!.id);
      }

      return response;
    } on AuthException {
      // Re-throw AuthException để bloc có thể xử lý
      rethrow;
    } catch (e) {
      // Wrap các lỗi khác thành AuthException
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancelled') ||
          errorString.contains('canceled')) {
        throw AuthException(
          'Đăng nhập với Google đã bị hủy.',
          statusCode: 'google_signin_cancelled',
        );
      }
      throw AuthException(
        'Đăng nhập với Google thất bại. Vui lòng thử lại.',
        statusCode: 'google_signin_failed',
      );
    }
  }

  // Đăng xuất
  Future<void> signOut({bool skipFCMTokenDeletion = false}) async {
    final user = _supabase.auth.currentUser;

    // Xóa FCM token trước khi đăng xuất (trừ khi skip)
    if (user != null && !skipFCMTokenDeletion) {
      try {
        await _fcmTokenService.deleteToken(user.id);
      } catch (e) {
        // Ignore error khi xóa FCM token
      }
    }

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  // Stream để lắng nghe thay đổi trạng thái đăng nhập
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
