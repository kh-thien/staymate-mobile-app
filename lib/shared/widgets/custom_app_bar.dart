import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stay_mate/features/profile/presentation/profile_bottom_sheet.dart';
import '../../features/auth/presentation/bloc/auth_bloc_exports.dart';
import '../../features/home/presentation/providers/notifications_provider.dart';
import '../../core/services/locale_provider.dart';
import '../../core/localization/app_localizations_helper.dart';
import '../../core/constants/app_styles.dart';
import '../providers/app_bar_provider.dart';
import 'user_avatar.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarState = ref.watch(appBarProvider);
    final title = appBarState.title;
    final actions = appBarState.actions;

    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Translate error message if it's a known network error key
          String errorMessage = state.message;
          if (state.message == 'NETWORK_ERROR_TRY_AGAIN') {
            errorMessage = AppLocalizationsHelper.translate(
              'networkErrorTryAgain',
              languageCode,
            );
          } else if (state.message == 'NETWORK_ERROR_CHECK_CONNECTION') {
            errorMessage = AppLocalizationsHelper.translate(
              'networkErrorCheckConnection',
              languageCode,
            );
          } else if (state.message.contains('Lỗi kết nối mạng') ||
              state.message.contains('kết nối mạng') ||
              state.message.contains('Network error') ||
              state.message.toLowerCase().contains('network')) {
            // Fallback for old hardcoded messages
            errorMessage = AppLocalizationsHelper.translate(
              'networkErrorTryAgain',
              languageCode,
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final authenticatedState =
            state is AuthAuthenticated ? state : null;
        final isLoggedIn = authenticatedState != null;

        final gradient = isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1F1F1F),
                  Color(0xFF2A2A2A),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDFCFB),
                  Color(0xFFE2EBFF),
                ],
              );

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? AppColors.borderDark
                      : Colors.white.withOpacity(0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.4)
                        : const Color(0xFF647DEE).withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
            ),
            child: Row(
              children: [
                Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: title != null
                        ? Text(
                            title,
                                key: ValueKey<String>(title),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : const Color(0xFF1F2937),
                                ),
                                textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                          )
                        : SizedBox(
                                key: const ValueKey<String>('logo'),
                                height: 52,
                            child: Image.asset(
                              'lib/core/assets/images/staymate_text_logo-removebg.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.centerLeft,
                                ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                    children: actions ??
                        [
                          _buildNotificationButton(context, ref),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showProfileBottomSheet(
                            context,
                            isLoggedIn,
                          ),
                          child: authenticatedState != null
                              ? UserAvatar(
                                  user: authenticatedState.user,
                                    displayName:
                                        authenticatedState.displayName,
                                  size: 24,
                                    backgroundColor:
                                        const Color(0xFF667EEA),
                                )
                                : Icon(
                                  Icons.person_rounded,
                                  size: 24,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : const Color(0xFF1F2937),
                                ),
                        ),
                      ],
                ),
              ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProfileBottomSheet(BuildContext context, bool isLoggedIn) {
    if (!isLoggedIn) {
      // Navigate to auth page if not logged in
      context.push('/auth');
    } else {
      // Show profile if logged in
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

  Widget _buildNotificationButton(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final unreadAsync = ref.watch(unreadNotificationsCountProvider);

    Widget baseButton() {
      return IconButton(
        onPressed: () {
          context.push('/notifications');
        },
        icon: Icon(
          Icons.notifications_rounded,
          color: isDark 
              ? AppColors.textPrimaryDark 
              : Colors.black,
        ),
        iconSize: 24,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    return unreadAsync.when(
      data: (count) {
        if (count <= 0) {
          return baseButton();
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            baseButton(),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => baseButton(),
      error: (_, __) => baseButton(),
    );
  }
}
