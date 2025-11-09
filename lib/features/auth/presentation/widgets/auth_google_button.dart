import 'package:flutter/material.dart';

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
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Image.asset(
          'lib/core/assets/images/google_logo.png',
          height: 20,
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[200] : Colors.grey[800],
          ),
        ),
      ),
    );
  }
}

