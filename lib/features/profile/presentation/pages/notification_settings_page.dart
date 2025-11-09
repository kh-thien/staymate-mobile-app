import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stay_mate/core/permission/permission_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  NotificationSettings? _notificationSettings;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _checkNotificationStatus();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkNotificationStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseMessaging = FirebaseMessaging.instance;
      final settings = await firebaseMessaging.getNotificationSettings();

      setState(() {
        _notificationSettings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi kiểm tra trạng thái: $e'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseMessaging = FirebaseMessaging.instance;
      final settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      setState(() {
        _notificationSettings = settings;
        _isLoading = false;
      });

      if (mounted) {
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Đã bật thông báo thành công!'),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Quyền thông báo bị từ chối'),
                ],
              ),
              backgroundColor: Colors.orange[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi yêu cầu quyền: $e'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _openSystemSettings() async {
    final opened = await PermissionService.openSettings();
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể mở cài đặt hệ thống'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Refresh status after returning from settings
      Future.delayed(const Duration(seconds: 1), () {
        _checkNotificationStatus();
      });
    }
  }

  Future<void> _onToggleSwitch(bool value) async {
    if (_isLoading) return;

    if (value) {
      // User wants to enable notifications
      if (_isAuthorized()) {
        // Already authorized, do nothing
        return;
      } else if (_isDenied()) {
        // Permission denied, open settings
        await _openSystemSettings();
      } else {
        // Not determined, request permission
        await _requestNotificationPermission();
      }
    } else {
      // User wants to disable notifications
      // Can only disable in system settings
      await _openSystemSettings();
    }
  }

  Color _getStatusColor() {
    if (_notificationSettings == null) {
      return Colors.grey;
    }

    switch (_notificationSettings!.authorizationStatus) {
      case AuthorizationStatus.authorized:
        return const Color(0xFF10B981); // Green
      case AuthorizationStatus.denied:
        return const Color(0xFFEF4444); // Red
      case AuthorizationStatus.notDetermined:
        return const Color(0xFFF59E0B); // Orange
      case AuthorizationStatus.provisional:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  IconData _getStatusIcon() {
    if (_notificationSettings == null) {
      return Icons.help_outline;
    }

    switch (_notificationSettings!.authorizationStatus) {
      case AuthorizationStatus.authorized:
        return Icons.notifications_active_rounded;
      case AuthorizationStatus.denied:
        return Icons.notifications_off_rounded;
      case AuthorizationStatus.notDetermined:
        return Icons.notifications_none_rounded;
      case AuthorizationStatus.provisional:
        return Icons.notifications_paused_rounded;
    }
  }

  bool _isAuthorized() {
    return _notificationSettings?.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  bool _isDenied() {
    return _notificationSettings?.authorizationStatus ==
        AuthorizationStatus.denied;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 24.0),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context),
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Cài đặt thông báo',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: _isLoading && _notificationSettings == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Đang kiểm tra...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hero Status Card
                            _buildHeroCard(theme, isDark),
                            const SizedBox(height: 32),

                            // Notification Types Section
                            Text(
                              'Loại thông báo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey[900],
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nhận thông báo về các cập nhật quan trọng:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildNotificationTypes(isDark),
                            const SizedBox(height: 32),

                            // Info Text
                            if (_isDenied() || !_isAuthorized())
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.orange[900]!.withOpacity(0.2)
                                      : Colors.orange[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.orange[700],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _isDenied()
                                            ? 'Để bật thông báo, vui lòng mở Cài đặt hệ thống và bật quyền thông báo cho ứng dụng.'
                                            : 'Bật công tắc phía trên để nhận thông báo từ ứng dụng.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.orange[900],
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_isDenied())
                              const SizedBox(height: 16),
                            // Action Button for denied state
                            if (_isDenied()) _buildSettingsButton(theme, isDark),
                            if (_isAuthorized())
                              const SizedBox(height: 16),
                            if (_isAuthorized())
                              _buildManageButton(theme, isDark),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(ThemeData theme, bool isDark) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final isEnabled = _isAuthorized();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEnabled
              ? [
                  statusColor.withOpacity(0.1),
                  statusColor.withOpacity(0.05),
                ]
              : [
                  Colors.grey[200]!.withOpacity(0.5),
                  Colors.grey[100]!.withOpacity(0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                size: 40,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 24),
            // Toggle Switch Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông báo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isAuthorized()
                            ? 'Đã bật'
                            : _isDenied()
                                ? 'Đã tắt'
                                : 'Chưa cấp quyền',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // iOS Style Switch
                Transform.scale(
                  scale: 1.1,
                  child: CupertinoSwitch(
                    value: isEnabled,
                    onChanged: _isLoading ? null : _onToggleSwitch,
                    activeColor: const Color(0xFF34C759), // iOS Green
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypes(bool isDark) {
    final types = [
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'title': 'Tin nhắn mới',
        'description': 'Nhận thông báo khi có tin nhắn mới',
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Cập nhật hợp đồng',
        'description': 'Thông báo về thay đổi hợp đồng',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.receipt_long_outlined,
        'title': 'Thông báo hóa đơn',
        'description': 'Nhắc nhở về hóa đơn cần thanh toán',
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Icons.flag_outlined,
        'title': 'Báo cáo mới',
        'description': 'Cập nhật về báo cáo và sự cố',
        'color': const Color(0xFFEF4444),
      },
    ];

    return Column(
      children: types.map((type) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (type['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type['icon'] as IconData,
                color: type['color'] as Color,
                size: 24,
              ),
            ),
            title: Text(
              type['title'] as String,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                type['description'] as String,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSettingsButton(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: OutlinedButton(
        onPressed: _isLoading ? null : _openSystemSettings,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : Colors.grey[900],
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Mở cài đặt hệ thống',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageButton(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: OutlinedButton(
        onPressed: _isLoading ? null : _openSystemSettings,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : Colors.grey[900],
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tune_rounded, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Quản lý trong cài đặt',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
