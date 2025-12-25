import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';

/// Chat AppBar with address information
class ChatDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String address;
  final String? ownerAvatar;
  final String? propertyName;
  final VoidCallback onOwnerTap;
  final VoidCallback onInfoTap;

  const ChatDetailAppBar({
    super.key,
    required this.address,
    this.ownerAvatar,
    this.propertyName,
    required this.onOwnerTap,
    required this.onInfoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDark 
          ? AppColors.surfaceDarkElevated 
          : Colors.white,
      foregroundColor: isDark 
          ? AppColors.textPrimaryDark 
          : Colors.black87,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1, 
          color: isDark 
              ? AppColors.dividerDark 
              : Colors.grey[200]!,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back, 
          color: isDark 
              ? AppColors.textPrimaryDark 
              : Colors.black87,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: InkWell(
        onTap: onOwnerTap,
        child: Row(
          children: [
            // Property Avatar/Icon
            _buildAddressAvatar(ownerAvatar, address),
            const SizedBox(width: 12),
            // Address
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark 
                          ? AppColors.textPrimaryDark 
                          : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (propertyName != null)
                    Text(
                      propertyName!,
                      style: TextStyle(
                        fontSize: 12, 
                        color: isDark 
                            ? AppColors.textSecondaryDark 
                            : Colors.grey[600]!,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.info_outline, 
            color: isDark 
                ? AppColors.textSecondaryDark 
                : Colors.grey[700]!,
          ),
          onPressed: onInfoTap,
          tooltip: 'Thông tin',
        ),
      ],
    );
  }

  /// Build address avatar widget (location icon)
  Widget _buildAddressAvatar(String? avatarUrl, String address) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          avatarUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) {
            return _buildLocationIcon();
          },
        ),
      );
    } else {
      return _buildLocationIcon();
    }
  }

  /// Build location icon
  Widget _buildLocationIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.location_on,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
