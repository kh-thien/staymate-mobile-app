import 'package:flutter/material.dart';
import 'package:stay_mate/features/profile/presentation/profile_bottom_sheet.dart';
import '../../features/auth/presentation/widgets/sign_in_bottom_sheet.dart';
import '../../core/services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Xin chào! 👋',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Chào mừng đến StayMate',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.person_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    _showProfileBottomSheet(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);

  void _showProfileBottomSheet(BuildContext context) {
    final authService = AuthService();

    if (!authService.isLoggedIn) {
      // Hiển thị form đăng nhập/đăng ký nếu chưa đăng nhập
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isDismissible: true,
        builder: (context) => const SignInBottomSheet(),
      );
    } else {
      // Hiển thị profile nếu đã đăng nhập
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isDismissible: true,
        builder: (context) => const ProfileBottomSheet(),
      );
    }
  }
}
