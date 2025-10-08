import 'package:flutter/material.dart';
import 'package:stay_mate/core/services/auth_service.dart';

class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
                              user?.userMetadata?['full_name'] ?? 'Người dùng',
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
                          title: 'Thông tin cá nhân',
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              // TODO: Navigate to profile page
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.description_outlined,
                          title: 'Hợp đồng của tôi',
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              // TODO: Navigate to contracts page
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.payment_outlined,
                          title: 'Thanh toán',
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              // TODO: Navigate to payments page
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Cài đặt',
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              // TODO: Navigate to settings page
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Trợ giúp',
                          onTap: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                              // TODO: Navigate to help page
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Đăng xuất',
                          onTap: () async {
                            if (context.mounted) {
                              Navigator.pop(context);
                              await authService.signOut();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã đăng xuất thành công!'),
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
}