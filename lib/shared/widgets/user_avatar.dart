import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Widget avatar người dùng có thể tái sử dụng
class UserAvatar extends StatelessWidget {
  final User? user;
  final String? displayName;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.user,
    this.displayName,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;
    final name =
        displayName ??
        user?.userMetadata?['full_name'] as String? ??
        user?.email?.split('@').first ??
        'User';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: avatarUrl != null && avatarUrl.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitialsAvatar(name);
                  },
                ),
              )
            : _buildInitialsAvatar(name),
      ),
    );
  }

  Widget _buildInitialsAvatar(String displayName) {
    // Lấy chữ cái đầu của tên
    final initials = displayName.isNotEmpty
        ? displayName
              .split(' ')
              .map((word) => word.isNotEmpty ? word[0] : '')
              .take(2)
              .join('')
              .toUpperCase()
        : 'U';

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Widget avatar với loading state
class UserAvatarWithLoading extends StatelessWidget {
  final User? user;
  final String? displayName;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const UserAvatarWithLoading({
    super.key,
    this.user,
    this.displayName,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.grey[300],
        ),
        child: Center(
          child: SizedBox(
            width: size * 0.5,
            height: size * 0.5,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? Colors.grey[600]!,
              ),
            ),
          ),
        ),
      );
    }

    return UserAvatar(
      user: user,
      displayName: displayName,
      size: size,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onTap: onTap,
    );
  }
}
