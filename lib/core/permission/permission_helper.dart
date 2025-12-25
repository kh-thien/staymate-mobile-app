import 'package:flutter/material.dart';
import 'permission_service.dart';

/// Widgets và helpers cho permission handling
class PermissionHelper {
  /// Hiển thị dialog yêu cầu quyền với giải thích
  static Future<bool> showPermissionDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Future<bool> Function() onRequestPermission,
  }) async {
    // Hiển thị dialog giải thích tại sao cần quyền
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cho phép'),
          ),
        ],
      ),
    );

    if (shouldRequest != true) return false;

    // Request permission
    return await onRequestPermission();
  }

  /// Hiển thị snackbar khi quyền bị từ chối
  static void showPermissionDeniedSnackBar({
    required BuildContext context,
    required String message,
    bool showSettingsAction = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange[700],
        action: showSettingsAction
            ? SnackBarAction(
                label: 'Cài đặt',
                textColor: Colors.white,
                onPressed: () => PermissionService.openSettings(),
              )
            : null,
      ),
    );
  }

  /// Hiển thị snackbar khi quyền bị từ chối vĩnh viễn
  static void showPermanentlyDeniedSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Mở cài đặt',
          textColor: Colors.white,
          onPressed: () => PermissionService.openSettings(),
        ),
      ),
    );
  }

  /// Request camera permission với UI feedback
  static Future<bool> requestCameraWithFeedback(BuildContext context) async {
    if (await PermissionService.isCameraGranted()) {
      return true;
    }

    if (await PermissionService.isCameraPermanentlyDenied()) {
      if (context.mounted) {
        showPermanentlyDeniedSnackBar(
          context: context,
          message: 'Quyền camera đã bị từ chối. Vui lòng bật trong Cài đặt.',
        );
      }
      return false;
    }

    final granted = await PermissionService.requestCameraPermission();

    if (!granted && context.mounted) {
      showPermissionDeniedSnackBar(
        context: context,
        message: 'Cần cấp quyền camera để chụp ảnh',
      );
    }

    return granted;
  }

  /// Request photos permission với UI feedback
  static Future<bool> requestPhotosWithFeedback(BuildContext context) async {
    if (await PermissionService.isPhotosGranted()) {
      return true;
    }

    if (await PermissionService.isPhotosPermanentlyDenied()) {
      if (context.mounted) {
        showPermanentlyDeniedSnackBar(
          context: context,
          message:
              'Quyền thư viện ảnh đã bị từ chối. Vui lòng bật trong Cài đặt.',
        );
      }
      return false;
    }

    final granted = await PermissionService.requestPhotosPermission();

    if (!granted && context.mounted) {
      showPermissionDeniedSnackBar(
        context: context,
        message: 'Cần cấp quyền truy cập thư viện ảnh',
      );
    }

    return granted;
  }

  /// Request storage permission với UI feedback
  static Future<bool> requestStorageWithFeedback(BuildContext context) async {
    // Kiểm tra nếu đã bị từ chối vĩnh viễn
    if (await PermissionService.isStoragePermanentlyDenied()) {
      if (context.mounted) {
        showPermanentlyDeniedSnackBar(
          context: context,
          message:
              'Quyền truy cập bộ nhớ đã bị từ chối. Vui lòng bật trong Cài đặt.',
        );
      }
      return false;
    }

    // Request permission
    final granted = await PermissionService.requestStoragePermission();

    if (!granted && context.mounted) {
      showPermissionDeniedSnackBar(
        context: context,
        message: 'Cần cấp quyền truy cập bộ nhớ',
      );
    }

    return granted;
  }
}
