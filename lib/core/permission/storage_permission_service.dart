import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle storage permission requests
class StoragePermissionService {
  /// Check and request storage permission
  /// Returns true if permission is granted, false otherwise
  static Future<bool> requestStoragePermission() async {
    // For Android 13+ (API 33+), we need to check photos/videos/audio permissions
    // For older Android versions, we check storage permission
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();

      if (androidInfo >= 33) {
        // Android 13+ - Use media permissions
        final photos = await Permission.photos.status;

        if (photos.isGranted) {
          return true;
        }

        // Request permission
        final result = await Permission.photos.request();
        return result.isGranted;
      } else {
        // Android 12 and below - Use storage permission
        final storage = await Permission.storage.status;

        if (storage.isGranted) {
          return true;
        }

        // Request permission
        final result = await Permission.storage.request();
        return result.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS - No permission needed for app documents directory
      // Files are saved to the app's documents folder which doesn't require permission
      return true;
    }

    // For other platforms, assume permission is granted
    return true;
  }

  /// Check if storage permission is already granted
  static Future<bool> isStoragePermissionGranted() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();

      if (androidInfo >= 33) {
        return await Permission.photos.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS doesn't need permission for app documents directory
      return true;
    }

    return true;
  }

  /// Open app settings for manual permission grant
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Get Android SDK version
  static Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;

    // Try to get Android version from device info
    // For simplicity, we'll check if photos permission exists
    // If it does, assume Android 13+
    try {
      await Permission.photos.status;
      // If photos permission is available, it's Android 13+
      return 33;
    } catch (e) {
      // If photos permission is not available, it's older Android
      return 29;
    }
  }
}
