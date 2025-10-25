import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// TODO: update the Web client ID with your own.
  ///
  /// Web Client ID that you registered with Google Cloud.
  final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;

  /// TODO: update the iOS client ID with your own.
  ///
  /// iOS Client ID that you registered with Google Cloud.
  final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID']!;

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.

  // Kiểm tra trạng thái đăng nhập
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Lấy thông tin user hiện tại
  User? get currentUser => _supabase.auth.currentUser;

  // Đăng nhập bằng email/password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Đăng ký bằng email/password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
      },
    );
  }

  // Đăng nhập bằng Google
  Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: webClientId,
      serverClientId: webClientId,
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthException('Google sign in cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Lắng nghe thay đổi trạng thái đăng nhập
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}