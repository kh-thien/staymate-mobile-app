import 'package:flutter/material.dart';

/// Google Sign In Button với UI đẹp hơn, tương tự Apple button
class AuthGoogleButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool isDark;

  const AuthGoogleButton({
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
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? Colors.grey[300]! : Colors.grey[700]!,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
        icon: Image.asset(
          'lib/core/assets/images/google_logo.png',
          height: 20,
          width: 20,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.g_mobiledata,
              size: 20,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            );
          },
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 17, // Match với Apple button font size để nhất quán
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[200] : Colors.grey[800],
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

