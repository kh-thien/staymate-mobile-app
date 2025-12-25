import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  final bool isDark;

  const AuthDivider({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey[300],
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'hoặc',
            style: TextStyle(
              color: isDark
                  ? Colors.grey[400]
                  : Colors.grey[500],
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

