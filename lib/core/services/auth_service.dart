import 'package:flutter/foundation.dart';
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
      debugPrint('🔵 [Google Sign-In] Starting Google Sign-In process...');
      
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Initialize with client IDs
      debugPrint('🔵 [Google Sign-In] Initializing GoogleSignIn with client IDs...');
      debugPrint('🔵 [Google Sign-In] iOS Client ID: ${iosClientId.substring(0, 20)}...');
      debugPrint('🔵 [Google Sign-In] Web Client ID: ${webClientId.substring(0, 20)}...');
      
      try {
        await googleSignIn.initialize(
          clientId: iosClientId,
          serverClientId: webClientId,
        );
        debugPrint('✅ [Google Sign-In] GoogleSignIn initialized successfully');
      } catch (initError) {
        debugPrint('❌ [Google Sign-In] Failed to initialize: $initError');
        throw AuthException(
          'Không thể khởi tạo Google Sign-In. Vui lòng kiểm tra cấu hình.',
          statusCode: 'google_signin_init_failed',
        );
      }

      debugPrint('🔵 [Google Sign-In] Calling authenticate()...');
      GoogleSignInAuthentication googleAuth;
      try {
        final googleUser = await googleSignIn.authenticate();
        debugPrint('✅ [Google Sign-In] authenticate() completed');
        debugPrint('🔵 [Google Sign-In] Getting authentication...');
        googleAuth = googleUser.authentication;
        debugPrint('✅ [Google Sign-In] Got authentication');
      } catch (authError) {
        debugPrint('❌ [Google Sign-In] Authentication error: $authError');
        final errorString = authError.toString().toLowerCase();
        
        // Check for specific error codes
        if (errorString.contains('cancelled') || errorString.contains('canceled')) {
          debugPrint('ℹ️ [Google Sign-In] User cancelled the sign-in');
          throw AuthException(
            'Đăng nhập với Google đã bị hủy.',
            statusCode: 'google_signin_cancelled',
          );
        }
        
        // Error 28444: Developer console is not set up correctly
        if (errorString.contains('28444') || 
            errorString.contains('developer console is not set up correctly') ||
            errorString.contains('developer_console_not_set_up')) {
          debugPrint('❌ [Google Sign-In] Error 28444 - Developer console not set up correctly');
          debugPrint('❌ [Google Sign-In] This usually means:');
          debugPrint('   1. SHA fingerprint not added to Google Cloud Console');
          debugPrint('   2. OAuth Client ID for Android not created');
          debugPrint('   3. Package name mismatch');
          throw AuthException(
            'Cấu hình Developer Console chưa đúng. Vui lòng:\n'
            '1. Thêm SHA fingerprint vào Google Cloud Console\n'
            '2. Tạo OAuth Client ID cho Android\n'
            '3. Kiểm tra package name khớp với com.staymate.mobile',
            statusCode: 'google_signin_developer_console_error',
          );
        }
        
        // Error 10: DEVELOPER_ERROR (SHA fingerprint issue)
        if (errorString.contains('10') || 
            errorString.contains('developer_error') ||
            errorString.contains('[10]')) {
          debugPrint('❌ [Google Sign-In] Error 10 - DEVELOPER_ERROR (SHA fingerprint issue)');
          throw AuthException(
            'Lỗi cấu hình Google Sign-In (Error 10).\n'
            'Vui lòng thêm SHA fingerprint của release keystore vào Google Cloud Console.\n'
            'Xem hướng dẫn trong file SUPABASE_GOOGLE_SIGNIN_FIX.md',
            statusCode: 'google_signin_developer_error',
          );
        }
        
        // Credential Manager error
        if (errorString.contains('credential') || 
            errorString.contains('credman') ||
            errorString.contains('getcredentialresponse')) {
          debugPrint('❌ [Google Sign-In] Credential Manager error');
          throw AuthException(
            'Lỗi Credential Manager.\n'
            'Vui lòng kiểm tra:\n'
            '1. SHA fingerprint đã được thêm vào Google Cloud Console\n'
            '2. OAuth Client ID cho Android đã được tạo\n'
            '3. Package name khớp với com.staymate.mobile',
            statusCode: 'google_signin_credential_error',
          );
        }
        
        rethrow;
      }

      final idToken = googleAuth.idToken;
      debugPrint('🔵 [Google Sign-In] ID Token: ${idToken != null ? "Received" : "NULL"}');

      if (idToken == null) {
        debugPrint('❌ [Google Sign-In] ID Token is null');
        throw AuthException(
          'Không thể lấy ID Token từ Google. Vui lòng thử lại.',
          statusCode: 'google_signin_no_id_token',
        );
      }

      debugPrint('🔵 [Google Sign-In] Signing in with Supabase...');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      debugPrint('✅ [Google Sign-In] Supabase sign-in successful');

      // Kiểm tra role và block admin
      if (response.user != null) {
        debugPrint('🔵 [Google Sign-In] Checking admin status...');
        await checkAndBlockAdmin(response.user!.id);
        debugPrint('✅ [Google Sign-In] Admin check passed');
        
        // Lưu FCM token sau khi đăng nhập thành công (chỉ khi không phải admin)
        debugPrint('🔵 [Google Sign-In] Saving FCM token...');
        await _fcmTokenService.saveToken(response.user!.id);
        debugPrint('✅ [Google Sign-In] FCM token saved');
      }

      debugPrint('✅ [Google Sign-In] Google Sign-In completed successfully');
      return response;
    } on AuthException catch (e) {
      debugPrint('❌ [Google Sign-In] AuthException: ${e.message} (${e.statusCode})');
      // Re-throw AuthException để bloc có thể xử lý
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ [Google Sign-In] Unexpected error: $e');
      debugPrint('❌ [Google Sign-In] Stack trace: $stackTrace');
      
      // Wrap các lỗi khác thành AuthException
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancelled') ||
          errorString.contains('canceled')) {
        throw AuthException(
          'Đăng nhập với Google đã bị hủy.',
          statusCode: 'google_signin_cancelled',
        );
      }
      
      // Check for network errors
      if (errorString.contains('network') || errorString.contains('connection')) {
        throw AuthException(
          'NETWORK_ERROR_CHECK_CONNECTION',
          statusCode: 'google_signin_network_error',
        );
      }
      
      throw AuthException(
        'Đăng nhập với Google thất bại: ${e.toString()}',
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
