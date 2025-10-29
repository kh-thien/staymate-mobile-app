import 'package:flutter/material.dart';
import '../../../../core/constants/ui_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  _buildWelcomeSection(),

                  const SizedBox(height: 30),

                  // Quick Actions
                  const Text(
                    'Thao tác nhanh',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Actions Grid - Có thể cuộn
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.only(
                        bottom: UIConstants.contentBottomPadding,
                      ),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildQuickActionCard(
                          context,
                          icon: Icons.qr_code_scanner_rounded,
                          title: 'Quét QR',
                          subtitle: 'Kết nối phòng',
                          color: const Color(0xFF4F46E5),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.description_rounded,
                          title: 'Hợp đồng',
                          subtitle: 'Theo dõi hợp đồng',
                          color: const Color(0xFFEC4899),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.electrical_services_rounded,
                          title: 'Điện nước',
                          subtitle: 'Tình trạng sử dụng',
                          color: const Color(0xFF10B981),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.chat_rounded,
                          title: 'Chat',
                          subtitle: 'Nhắn tin chủ nhà',
                          color: const Color(0xFFF59E0B),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.receipt_long_rounded,
                          title: 'Hóa đơn',
                          subtitle: 'Thanh toán',
                          color: const Color(0xFF8B5CF6),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.report_problem_rounded,
                          title: 'Báo cáo',
                          subtitle: 'Sự cố phòng',
                          color: const Color(0xFFEF4444),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.settings_rounded,
                          title: 'Cài đặt',
                          subtitle: 'Tùy chỉnh',
                          color: const Color(0xFF6B7280),
                          onTap: () {},
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.help_rounded,
                          title: 'Hỗ trợ',
                          subtitle: 'Trợ giúp',
                          color: const Color(0xFF06B6D4),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theo dõi hợp đồng trọ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quét QR code hoặc nhập mã để kết nối với chủ nhà',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Color(0xFF667eea),
                    ),
                    label: const Text(
                      'Quét QR Code',
                      style: TextStyle(
                        color: Color(0xFF667eea),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.keyboard_rounded,
                      color: Color(0xFF667eea),
                    ),
                    label: const Text(
                      'Nhập mã',
                      style: TextStyle(
                        color: Color(0xFF667eea),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
