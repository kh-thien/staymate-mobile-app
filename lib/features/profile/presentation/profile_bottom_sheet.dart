import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/auth_service.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import 'package:stay_mate/core/localization/app_localizations_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';


class ProfileBottomSheet extends ConsumerWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final authService = AuthService();
    final user = authService.currentUser;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
              color: Colors.grey[300],
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
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            user?.userMetadata?['avatar_url'] != null
                            ? NetworkImage(user!.userMetadata!['avatar_url'])
                            : null,
                        child: user?.userMetadata?['avatar_url'] == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'user@example.com',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
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
                        icon: const Icon(Icons.close),
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
                              // TODO: Navigate to profile page
                            }
                          },
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
                              // TODO: Navigate to settings page
                            }
                          },
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
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: AppLocalizationsHelper.translate(
                            'help',
                            languageCode,
                          ),
                          onTap: () async {
                            if (context.mounted) {
                              Navigator.pop(context);
                              await _openEmailSupport(context, ref);
                            }
                          },
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.grey[50],
      ),
    );
  }

  Future<void> _openEmailSupport(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;
    final String email = 'staymate.home@gmail.com';
    final String subject = AppLocalizationsHelper.translate(
      'supportFromStayMate',
      languageCode,
    );
    final Uri emailUri = Uri.parse('mailto:$email?subject=${Uri.encodeComponent(subject)}');

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizationsHelper.translate(
                  'cannotOpenEmailApp',
                  languageCode,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('anErrorOccurredMessage', languageCode)}: $e',
            ),
          ),
        );
      }
    }
  }
}
