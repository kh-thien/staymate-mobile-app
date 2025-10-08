import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    return Container(
      margin: const EdgeInsets.fromLTRB(50, 0,50, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Theo dõi
                _buildNavItem(
                  icon: Icons.home_work_rounded,
                  label: 'Theo dõi',
                  isSelected: currentLocation == '/tracking',
                  onTap: () {
                    context.go('/tracking');
                  },
                ),

                // Trang chủ (nổi bật)
                _buildHomeButton(context, currentLocation == '/'),

                // Chat
                _buildNavItem(
                  icon: Icons.chat_rounded,
                  label: 'Chat',
                  isSelected: currentLocation == '/chat',
                  onTap: () {
                    context.go('/chat');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF667eea) : Colors.grey[400],
            size: 22,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF667eea) : Colors.grey[400],
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.go('/');
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF667eea).withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.home_rounded,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}
