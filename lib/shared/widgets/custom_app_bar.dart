import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stay_mate/features/profile/presentation/profile_bottom_sheet.dart';
import '../../features/auth/presentation/widgets/sign_in_bottom_sheet.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';
import 'user_avatar.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _showWelcomeText = true;
  Timer? _timer;
  String? _lastAuthenticatedUserId;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startWelcomeTimer(String userId) {
    // Only start timer if this is a new login (different user or first time)
    if (_lastAuthenticatedUserId != userId) {
      _lastAuthenticatedUserId = userId;
      _showWelcomeText = true;

      // Cancel existing timer if any
      _timer?.cancel();

      // Start 30 second timer
      _timer = Timer(const Duration(seconds: 30), () {
        if (mounted) {
          setState(() {
            _showWelcomeText = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        String userName = '';
        bool isLoggedIn = false;
        String? userId;

        if (state is AuthAuthenticated) {
          userName = state.displayName;
          isLoggedIn = true;
          userId = state.user.id;

          // Start timer when user is authenticated
          _startWelcomeTimer(userId);
        } else {
          userName = 'tới StayMate!';
          isLoggedIn = false;
          _lastAuthenticatedUserId = null;
          _showWelcomeText = true;
          _timer?.cancel();
        }

        final authenticatedState = isLoggedIn
            ? state as AuthAuthenticated
            : null;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoggedIn && _showWelcomeText) ...[
                      const Text(
                        'Chào mừng',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$userName!',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      SvgPicture.asset(
                        'lib/core/assets/images/staymate_text_logo.svg',
                        height: 70,
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
    );
  }

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
