import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stay_mate/features/profile/presentation/profile_bottom_sheet.dart';
import '../../features/auth/presentation/widgets/sign_in_bottom_sheet.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';
import 'user_avatar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          String userName = '';
          bool isLoggedIn = false;

          if (state is AuthAuthenticated) {
            userName = state.displayName;
            isLoggedIn = true;
          } else {
            userName = 'tới StayMate!';
            isLoggedIn = false;
          }

          final authenticatedState = isLoggedIn
              ? state as AuthAuthenticated
              : null;

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (isLoggedIn) ...[
                        const Text(
                          'Chào mừng',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$userName!',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Chào mừng tới StayMate!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'vui lòng đăng nhập',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                      icon: isLoggedIn
                          ? UserAvatar(
                              user: authenticatedState!.user,
                              displayName: authenticatedState.displayName,
                              size: 24,
                              backgroundColor: Colors.blue,
                            )
                          : const Icon(
                              Icons.person_rounded,
                              color: Colors.black,
                              size: 24,
                            ),
                      onPressed: () {
                        _showProfileBottomSheet(context, isLoggedIn);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);

  void _showProfileBottomSheet(BuildContext context, bool isLoggedIn) {
    if (!isLoggedIn) {
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
