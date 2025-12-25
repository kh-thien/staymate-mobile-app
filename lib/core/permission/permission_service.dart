import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Service để quản lý các quyền (permissions) của ứng dụng
class PermissionService {
  /// Xin quyền camera
  ///
  /// Returns: true nếu được cấp quyền, false nếu bị từ chối
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Xin quyền thư viện ảnh
  ///
  /// Returns: true nếu được cấp quyền, false nếu bị từ chối
  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    // iOS 14+: Accept both granted and limited access
    // Limited = user selected specific photos (still valid for image_picker)
    return status.isGranted || status.isLimited;
  }

  /// Xin quyền storage (Android)
  ///
  /// Returns: true nếu được cấp quyền, false nếu bị từ chối
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ (API 33+) không cần storage permission khi dùng System File Picker
      // FilePicker.platform.pickFiles() tự động dùng Storage Access Framework
      if (await _isAndroid13OrAbove()) {
        // Không cần request permission, return true
        return true;
      } else {
        // Android 12 và thấp hơn
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    // iOS không cần storage permission riêng
    return true;
  }

  /// Xin quyền microphone (cho voice messages)
  ///
  /// Returns: true nếu được cấp quyền, false nếu bị từ chối
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Kiểm tra trạng thái quyền camera
  static Future<bool> isCameraGranted() async {
    return await Permission.camera.isGranted;
  }

  /// Kiểm tra trạng thái quyền photos
  static Future<bool> isPhotosGranted() async {
    final status = await Permission.photos.status;
    // iOS 14+: Accept both granted and limited access
    return status.isGranted || status.isLimited;
  }

  /// Kiểm tra trạng thái quyền storage
  static Future<bool> isStorageGranted() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrAbove()) {
        return await Permission.photos.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    }
    return true;
  }

  /// Kiểm tra trạng thái quyền microphone
  static Future<bool> isMicrophoneGranted() async {
    return await Permission.microphone.isGranted;
  }

  /// Kiểm tra nếu quyền bị từ chối vĩnh viễn
  static Future<bool> isCameraPermanentlyDenied() async {
    return await Permission.camera.isPermanentlyDenied;
  }

  /// Kiểm tra nếu quyền photos bị từ chối vĩnh viễn
  static Future<bool> isPhotosPermanentlyDenied() async {
    return await Permission.photos.isPermanentlyDenied;
  }

  /// Kiểm tra nếu quyền storage bị từ chối vĩnh viễn
  static Future<bool> isStoragePermanentlyDenied() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrAbove()) {
        return await Permission.photos.isPermanentlyDenied;
      } else {
        return await Permission.storage.isPermanentlyDenied;
      }
    }
    return false;
  }

  /// Mở trang cài đặt ứng dụng để người dùng cấp quyền thủ công
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Kiểm tra Android version >= 13 (API 33)
  static Future<bool> _isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return false;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33; // Android 13 (API 33)
    } catch (e) {
      // Nếu không kiểm tra được, giả định là Android cũ (cần storage permission)
      return false;
    }
  }

  /// Xin tất cả quyền cần thiết cho chat feature
  ///
  /// Returns: Map với key là tên permission và value là granted status
  static Future<Map<String, bool>> requestAllChatPermissions() async {
    return {
      'camera': await requestCameraPermission(),
      'photos': await requestPhotosPermission(),
      'storage': await requestStoragePermission(),
    };
  }

  /// Kiểm tra tất cả quyền chat đã được cấp chưa
  static Future<bool> areAllChatPermissionsGranted() async {
    final camera = await isCameraGranted();
    final photos = await isPhotosGranted();
    final storage = await isStorageGranted();

    return camera && photos && storage;
  }
}
