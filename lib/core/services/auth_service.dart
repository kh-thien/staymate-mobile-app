import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// TODO: update the Web client ID with your own.
  ///
  /// Web Client ID that you registered with Google Cloud.
  final webClientId =
      '813920614773-nhmiiclsdkgn0jg7f4o9j7tlgvukup81.apps.googleusercontent.com';

  /// TODO: update the iOS client ID with your own.
  ///
  /// iOS Client ID that you registered with Google Cloud.
  final iosClientId =
      '813920614773-orvqh39ie44ptdp8gloc0j7pgtv7cd2d.apps.googleusercontent.com';

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
      data: {'full_name': fullName},
    );
  }

  // Đăng nhập bằng Google
  Future<AuthResponse> signInWithGoogle() async {
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
      throw 'No ID Token found.';
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  // Đăng xuất
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  // Stream để lắng nghe thay đổi trạng thái đăng nhập
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
