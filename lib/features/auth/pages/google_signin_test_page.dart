import 'package:flutter/material.dart';
import 'package:stay_mate/core/services/auth_service.dart';

class GoogleSignInTestPage extends StatefulWidget {
  const GoogleSignInTestPage({super.key});

  @override
  State<GoogleSignInTestPage> createState() => _GoogleSignInTestPageState();
}

class _GoogleSignInTestPageState extends State<GoogleSignInTestPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _testGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await _authService.signInWithGoogle();
      if (response.user != null) {
        setState(() {
          _successMessage =
              'Đăng nhập thành công!\nEmail: ${response.user?.email}\nID: ${response.user?.id}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            const Text(
              'Test Google Sign-In',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nhấn nút bên dưới để test Google Sign-In với Supabase',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _testGoogleSignIn,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.login),
                label: Text(
                  _isLoading ? 'Đang đăng nhập...' : 'Đăng nhập với Google',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_successMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              'Lưu ý: Đảm bảo đã cấu hình:\n'
              '1. SHA-1 fingerprint trong Google Cloud Console\n'
              '2. Google provider trong Supabase Dashboard\n'
              '3. Client ID và Client Secret',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
