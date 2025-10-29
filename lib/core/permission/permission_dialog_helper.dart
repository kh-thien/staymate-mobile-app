import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Helper class to show permission dialogs
class PermissionDialogHelper {
  /// Show dialog when permission is denied
  static Future<void> showPermissionDeniedDialog(
    BuildContext context, {
    required String title,
    required String message,
    bool showSettingsButton = true,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          if (showSettingsButton)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text('Mở cài đặt'),
            ),
        ],
      ),
    );
  }

  /// Show dialog requesting storage permission
  static Future<bool?> showStoragePermissionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cần quyền truy cập'),
        content: const Text(
          'Ứng dụng cần quyền truy cập bộ nhớ để tải xuống file. '
          'Bạn có muốn cấp quyền không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Từ chối'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }
}
