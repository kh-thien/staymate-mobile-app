# iOS Compatibility Guide

## ✅ Tóm tắt: Code ĐÃ tương thích với iOS

### Đã implement:

#### 1. **Permission Handling** ✅
- `StoragePermissionService` tự động detect iOS và sử dụng `Permission.photos`
- Tự động request permission khi cần download
- Show dialog khi permission bị từ chối với option mở Settings

#### 2. **File Download** ✅
- **Images (.png, .jpg)**: Lưu trực tiếp vào **Photos Library** qua `GallerySaver`
- **PDF/Documents**: Download về temp directory, user có thể share/open

#### 3. **iOS Permissions (Info.plist)** ✅
```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Ứng dụng cần quyền truy cập thư viện ảnh để lưu file hợp đồng đã tải xuống.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Ứng dụng cần quyền truy cập thư viện ảnh để lưu file hợp đồng.</string>
```

### Dependencies cần thiết:

```yaml
dependencies:
  permission_handler: ^11.3.1   # Xin permission
  gallery_saver: ^2.3.2          # Lưu ảnh vào Photos (iOS)
  path_provider: ^2.1.5          # Truy cập directories
  dio: ^5.9.0                     # Download files
```

## 🎯 Hoạt động trên iOS:

### Khi user bấm Download:

1. **Check Permission**
   - Gọi `StoragePermissionService.requestStoragePermission()`
   - iOS → Check `Permission.photos`
   
2. **Request nếu chưa có**
   - Show iOS system permission dialog
   - User chọn: "Allow" hoặc "Don't Allow"

3. **Download File**
   - **Nếu là ảnh**: 
     * Download về temp directory
     * `GallerySaver.saveImage()` → Lưu vào Photos
     * Show message: "Đã lưu ảnh vào thư viện Photos"
   - **Nếu là PDF**:
     * Download về temp directory
     * Show message: "Đã tải xuống file"
     * User có thể share hoặc mở bằng app khác

4. **Nếu Permission bị từ chối**
   - Show dialog với nút "Mở cài đặt"
   - User có thể vào Settings → StayMate → Photos → Enable

## 📱 User Experience trên iOS:

### Ảnh hợp đồng (PNG/JPG):
✅ Lưu vào **Photos app**
✅ User có thể tìm thấy trong album "Recents"
✅ Có thể chia sẻ, chỉnh sửa như ảnh bình thường

### PDF hợp đồng:
⚠️ Không lưu trực tiếp vào Files app (iOS limitation)
✅ Download về app temp directory
💡 User có thể:
- Mở bằng app khác (Preview, Adobe, etc.)
- Share qua AirDrop, Messages, Email
- Save to Files manually

## 🔄 Khác biệt Android vs iOS:

| Feature | Android | iOS |
|---------|---------|-----|
| **Permission** | Storage (old) / Photos (13+) | Photos only |
| **Image Save** | `/Download/` folder | Photos Library |
| **PDF Save** | `/Download/` folder | Temp (share/open) |
| **User Access** | File Manager | Photos app / Share sheet |
| **Open in App** | ✅ Direct link | ⚠️ Via share |

## 🚨 iOS Limitations:

1. **Không có Downloads folder công khai**
   - iOS không cho phép app lưu trực tiếp vào Files → Downloads
   - Workaround: Lưu vào Photos (images) hoặc Share sheet (documents)

2. **Documents cần Share Sheet**
   - PDF không thể lưu trực tiếp
   - User phải dùng iOS Share sheet để lưu vào Files

3. **Sandbox restrictions**
   - App chỉ truy cập được app documents directory
   - Không access được system folders

## ✨ Cải tiến tương lai (Optional):

### 1. Share Sheet cho PDF (iOS)
```dart
import 'package:share_plus/share_plus.dart';

// Thay vì chỉ show message, cho phép share
await Share.shareXFiles([XFile(filePath)], text: 'Hợp đồng');
```

### 2. Save to Files app (iOS)
```dart
import 'package:file_picker/file_picker.dart';

// Let user choose save location
String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
```

### 3. Quick Look Preview (iOS)
```dart
import 'package:flutter_file_view/flutter_file_view.dart';

// Preview PDF before saving
await FlutterFileView.init();
await FlutterFileView.open(filePath);
```

## 🧪 Testing trên iOS:

### Simulator:
```bash
flutter run -d "iPhone 15 Pro"
```

### Real Device:
```bash
flutter run -d "Your iPhone"
# Cần Apple Developer account để sign
```

### Test Cases:
1. ✅ Download image → Check Photos app
2. ✅ Permission denied → Check dialog shows Settings button
3. ✅ Re-request permission → Should work after enabling in Settings
4. ✅ Download PDF → Can open with external app
5. ✅ Multiple downloads → Each file saved separately

## 📖 References:

- [iOS Photo Library Usage](https://developer.apple.com/documentation/photokit)
- [Flutter permission_handler](https://pub.dev/packages/permission_handler)
- [gallery_saver package](https://pub.dev/packages/gallery_saver)
- [iOS File System Programming Guide](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/)
