# Permission Management

Thư mục này chứa các service và helper để quản lý quyền truy cập (permissions) trong ứng dụng.

## Files

### 1. `storage_permission_service.dart`
Service quản lý quyền truy cập bộ nhớ/photos.

**Features:**
- Tự động phát hiện Android version (13+ vs cũ hơn)
- Android 13+: Sử dụng `Permission.photos`
- Android < 13: Sử dụng `Permission.storage`
- iOS: Sử dụng `Permission.photos`

**Usage:**
```dart
// Check và request permission
final hasPermission = await StoragePermissionService.requestStoragePermission();

if (hasPermission) {
  // Download file
} else {
  // Show error or request again
}

// Chỉ check permission không request
final isGranted = await StoragePermissionService.isStoragePermissionGranted();
```

### 2. `permission_dialog_helper.dart`
Helper để hiển thị dialog liên quan đến permissions.

**Methods:**

**showPermissionDeniedDialog** - Hiển thị dialog khi permission bị từ chối
```dart
await PermissionDialogHelper.showPermissionDeniedDialog(
  context,
  title: 'Quyền truy cập bị từ chối',
  message: 'Ứng dụng cần quyền...',
  showSettingsButton: true, // Hiển thị nút "Mở cài đặt"
);
```

**showStoragePermissionDialog** - Hiển thị dialog xin phép trước khi request
```dart
final shouldRequest = await PermissionDialogHelper.showStoragePermissionDialog(context);

if (shouldRequest == true) {
  // User agreed, request permission
  await StoragePermissionService.requestStoragePermission();
}
```

## Setup Required

### Android Permissions (AndroidManifest.xml)
```xml
<!-- For Android 12 and below -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />

<!-- For Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

### iOS Permissions (Info.plist)
```xml
<!-- Permission descriptions for iOS -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Ứng dụng cần quyền truy cập thư viện ảnh để lưu file hợp đồng đã tải xuống.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Ứng dụng cần quyền truy cập thư viện ảnh để lưu file hợp đồng.</string>
```

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  permission_handler: ^11.3.1
  dio: ^5.9.0              # For downloading files
  path_provider: ^2.1.5    # For accessing directories
```

## Example: Download File with Permission

```dart
import 'package:stay_mate/core/permission/permission.dart';

Future<void> downloadFile() async {
  // Request permission
  final hasPermission = await StoragePermissionService.requestStoragePermission();
  
  if (hasPermission) {
    // Download file
    await _performDownload();
  } else {
    // Show dialog with option to open settings
    if (mounted) {
      await PermissionDialogHelper.showPermissionDeniedDialog(
        context,
        title: 'Quyền truy cập bị từ chối',
        message: 'Vui lòng cấp quyền trong cài đặt.',
      );
    }
  }
}
```

## Platform-Specific Behaviors

### Android
- **Android 13+ (API 33+)**: Sử dụng `Permission.photos` (scoped storage)
- **Android 12 và cũ hơn**: Sử dụng `Permission.storage`
- File được lưu vào: `/storage/emulated/0/Download/`
- User có thể mở file trực tiếp từ app hoặc File Manager

### iOS
- Luôn sử dụng `Permission.photos`
- File được lưu vào: **App Documents Directory**
- User có thể truy cập qua: **Files app → On My iPhone → StayMate**
- Hoặc share file qua AirDrop, Messages, Email
- iOS không cho phép lưu trực tiếp vào Downloads folder (system limitation)

## Notes

- Service tự động xử lý khác biệt giữa Android versions
- Trên Android 13+, `WRITE_EXTERNAL_STORAGE` không còn cần thiết
- iOS luôn yêu cầu `Permission.photos` để lưu vào Photos Library
- Nếu cần lưu file vào app directory (không cần permission), sử dụng `getApplicationDocumentsDirectory()`
- iOS không cho phép lưu trực tiếp vào Files app Downloads folder
