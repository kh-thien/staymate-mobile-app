import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/features/profile/presentation/profile_bottom_sheet.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';
import 'user_avatar.dart';
import 'internet_status_indicator.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        final authenticatedState =
            state is AuthAuthenticated ? state : null;
        final isLoggedIn = authenticatedState != null;

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layout ban đầu - giữ nguyên như cũ
                Row(
                  children: [
                    // Logo - Expanded để tránh overflow
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: Image.asset(
                          'lib/core/assets/images/staymate_text_logo-removebg.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.push('/notifications');
                          },
                          icon: const Icon(Icons.notifications_rounded),
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showProfileBottomSheet(
                            context,
                            isLoggedIn,
                          ),
                          child: authenticatedState != null
                              ? UserAvatar(
                                  user: authenticatedState.user,
                                  displayName: authenticatedState.displayName,
                                  size: 24,
                                  backgroundColor: Colors.blue,
                                )
                              : const Icon(
                                  Icons.person_rounded,
                                  size: 24,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Internet Status Indicator - Overlay ở giữa
                const InternetStatusIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProfileBottomSheet(BuildContext context, bool isLoggedIn) {
    if (!isLoggedIn) {
      // Navigate đến auth page nếu chưa đăng nhập
      context.push('/auth');
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
