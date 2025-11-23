import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/auth_service.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import 'package:stay_mate/core/services/theme_provider.dart';
import 'package:stay_mate/core/localization/app_localizations_helper.dart';
import 'package:stay_mate/core/constants/app_styles.dart';
import 'package:go_router/go_router.dart';


class ProfileBottomSheet extends ConsumerWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final authService = AuthService();
    final user = authService.currentUser;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.surfaceDarkElevated 
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark 
                  ? AppColors.dividerDark 
                  : Colors.grey[300]!,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Profile content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: isDark 
                            ? AppColors.surfaceDark 
                            : Colors.grey[200]!,
                        backgroundImage:
                            user?.userMetadata?['avatar_url'] != null
                            ? NetworkImage(user!.userMetadata!['avatar_url'])
                            : null,
                        child: user?.userMetadata?['avatar_url'] == null
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: isDark 
                                    ? AppColors.textSecondaryDark 
                                    : Colors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.userMetadata?['full_name'] ??
                                  AppLocalizationsHelper.translate(
                                    'user',
                                    languageCode,
                                  ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark 
                                    ? AppColors.textPrimaryDark 
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'user@example.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark 
                                    ? AppColors.textSecondaryDark 
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.close,
                          color: isDark 
                              ? AppColors.textPrimaryDark 
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Menu items
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: AppLocalizationsHelper.translate(
                            'personalInfo',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.push('/profile/personal-info');
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: AppLocalizationsHelper.translate(
                            'account',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.push('/profile/account');
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: AppLocalizationsHelper.translate(
                            'notifications',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.push('/notification-settings');
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.language,
                          title: AppLocalizationsHelper.translate(
                            'language',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.push('/language-settings');
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.palette_outlined,
                          title: AppLocalizationsHelper.translate(
                            'theme',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              _showThemeSelector(context, ref);
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.info_outline,
                          title: AppLocalizationsHelper.translate(
                            'appInfo',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.push('/app-info');
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.feedback_outlined,
                          title: AppLocalizationsHelper.translate(
                            'sendFeedback',
                            languageCode,
                          ),
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              context.push('/feedback');
                            }
                          },
                          context: context,
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: AppLocalizationsHelper.translate(
                            'logout',
                            languageCode,
                          ),
                          onTap: () async {
                            if (context.mounted) {
                              Navigator.pop(context);
                              await authService.signOut();
                              if (context.mounted) {
                                final locale = ref.read(appLocaleProvider);
                                final languageCode = locale.languageCode;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizationsHelper.translate(
                                        'loggedOutSuccessfully',
                                        languageCode,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          isDestructive: true,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive 
              ? Colors.red 
              : (isDark 
                  ? AppColors.textSecondaryDark 
                  : Colors.grey[600]!),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive 
                ? Colors.red 
                : (isDark 
                    ? AppColors.textPrimaryDark 
                    : Colors.black),
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: isDark 
            ? AppColors.surfaceDark 
            : Colors.grey[50],
      ),
    );
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;
    final themeModeAsync = ref.read(themeModeProvider);
    
    // Get current theme mode, default to system if loading or error
    final currentThemeMode = themeModeAsync.when(
      data: (mode) => mode,
      loading: () => ThemeMode.system,
      error: (_, __) => ThemeMode.system,
    );
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ThemeSelectorBottomSheet(
        currentThemeMode: currentThemeMode,
        languageCode: languageCode,
      ),
    );
  }

}

/// Theme Selector Bottom Sheet
class _ThemeSelectorBottomSheet extends ConsumerWidget {
  final ThemeMode currentThemeMode;
  final String languageCode;

  const _ThemeSelectorBottomSheet({
    required this.currentThemeMode,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.surfaceDarkElevated 
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark 
                  ? AppColors.dividerDark 
                  : Colors.grey[300]!,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  AppLocalizationsHelper.translate('selectTheme', languageCode),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark 
                        ? AppColors.textPrimaryDark 
                        : Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark 
                        ? AppColors.textSecondaryDark 
                        : Colors.grey[600]!,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Theme options
          _ThemeOption(
            themeMode: ThemeMode.light,
            icon: Icons.light_mode_outlined,
            title: AppLocalizationsHelper.translate('themeLight', languageCode),
            isSelected: currentThemeMode == ThemeMode.light,
            languageCode: languageCode,
          ),
          _ThemeOption(
            themeMode: ThemeMode.dark,
            icon: Icons.dark_mode_outlined,
            title: AppLocalizationsHelper.translate('themeDark', languageCode),
            isSelected: currentThemeMode == ThemeMode.dark,
            languageCode: languageCode,
          ),
          _ThemeOption(
            themeMode: ThemeMode.system,
            icon: Icons.brightness_auto_outlined,
            title: AppLocalizationsHelper.translate('themeSystem', languageCode),
            isSelected: currentThemeMode == ThemeMode.system,
            languageCode: languageCode,
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _ThemeOption extends ConsumerWidget {
  final ThemeMode themeMode;
  final IconData icon;
  final String title;
  final bool isSelected;
  final String languageCode;

  const _ThemeOption({
    required this.themeMode,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : (isDark 
                ? AppColors.textSecondaryDark 
                : Colors.grey[600]!),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDark 
                  ? AppColors.textPrimaryDark 
                  : Colors.black87),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: () async {
        final notifier = ref.read(themeModeProvider.notifier);
        await notifier.setThemeMode(themeMode);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      tileColor: isDark 
          ? AppColors.surfaceDark 
          : Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
