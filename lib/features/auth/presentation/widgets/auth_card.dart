import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';

class AuthCard extends StatelessWidget {
  final bool isDark;
  final TabController tabController;
  final Widget signInTab;
  final Widget signUpTab;

  const AuthCard({
    super.key,
    required this.isDark,
    required this.tabController,
    required this.signInTab,
    required this.signUpTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withOpacity(0.8)
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: Column(
          children: [
          // Tab Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                    ? Colors.grey[400]
                    : Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Đăng nhập'),
                  Tab(text: 'Đăng ký'),
                ],
              ),
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                signInTab,
                signUpTab,
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}

