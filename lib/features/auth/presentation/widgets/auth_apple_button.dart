import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Apple Sign In Button tuân thủ Apple Human Interface Guidelines
/// 
/// Apple yêu cầu:
/// 1. Sử dụng SignInWithAppleButton từ package sign_in_with_apple
/// 2. Không được tùy chỉnh quá nhiều (màu sắc, kích thước)
/// 3. Phải hiển thị rõ ràng và dễ nhận biết
/// 
/// Lưu ý: SignInWithAppleButton chỉ hỗ trợ text tiếng Anh theo Apple guidelines.
/// Để hiển thị tiếng Việt, chúng ta sử dụng custom button với style tương tự.
class AuthAppleButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool isDark;

  const AuthAppleButton({
    super.key,
    required this.text,
    required this.isLoading,
    this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading state
    if (isLoading) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    // Kiểm tra xem text có phải tiếng Việt không
    final isVietnamese = text.contains('Đăng') || text.contains('đăng');
    
    if (isVietnamese) {
      // Nếu là tiếng Việt, sử dụng custom button với style giống Apple
      // (vì SignInWithAppleButton chỉ hỗ trợ tiếng Anh)
    return Container(
        height: 50,
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton.icon(
          onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
          ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        icon: Icon(
          Icons.apple,
          size: 20,
          color: isDark ? Colors.black : Colors.white,
        ),
        label: Text(
          text,
          style: TextStyle(
              fontSize: 17, // Match với Apple button font size
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.black : Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
    }

    // Nếu là tiếng Anh, sử dụng SignInWithAppleButton chính thức từ package
    // Đây là cách đúng nhất để tuân thủ Apple HIG
    return SizedBox(
      height: 50,
      child: SignInWithAppleButton(
        onPressed: onPressed,
        text: _getButtonText(text),
        height: 50,
        style: isDark
            ? SignInWithAppleButtonStyle.white
            : SignInWithAppleButtonStyle.black,
      ),
    );
  }

  /// Chuyển đổi text để phù hợp với Apple button
  /// Apple button hỗ trợ: "Sign in with Apple", "Sign up with Apple", "Continue with Apple"
  String _getButtonText(String originalText) {
    final lowerText = originalText.toLowerCase();
    if (lowerText.contains('sign up') || lowerText.contains('đăng ký')) {
      return 'Sign up with Apple';
    } else {
      return 'Sign in with Apple';
    }
  }

}

