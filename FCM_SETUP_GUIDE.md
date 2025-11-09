# Firebase Cloud Messaging (FCM) Setup Guide

## ✅ Đã cấu hình

### 1. Dependencies
- ✅ `firebase_core: ^3.8.1` - Firebase core SDK
- ✅ `firebase_messaging: ^16.0.4` - Firebase Cloud Messaging

### 2. Android Configuration
- ✅ **Google Services Plugin**: Đã thêm vào `settings.gradle.kts` và `build.gradle.kts`
- ✅ **google-services.json**: Đã có tại `android/app/google-services.json`
- ✅ **AndroidManifest.xml**: 
  - Đã thêm permissions: `POST_NOTIFICATIONS`, `VIBRATE`, `RECEIVE_BOOT_COMPLETED`
  - Đã thêm Firebase Messaging Service
  - Đã thêm default notification channel

### 3. Flutter Code
- ✅ **FirebaseMessagingService**: Service để xử lý FCM notifications
- ✅ **Firebase Initialization**: Đã khởi tạo Firebase trong `main.dart`
- ✅ **Background Message Handler**: Đã đăng ký handler cho background messages

## 📋 Các bước tiếp theo

### 1. Chạy `flutter pub get`
```bash
flutter pub get
```

### 2. Test FCM Token
Sau khi khởi chạy app, kiểm tra logs để xem FCM token:
```
FCM Token: <your-token-here>
```

### 3. Lưu FCM Token vào Database
Cần lưu FCM token vào Supabase database để server có thể gửi notifications:

```dart
// Ví dụ: Lưu token vào users table
final token = await firebaseMessagingService.getToken();
if (token != null && user != null) {
  await supabase
    .from('users')
    .update({'fcm_token': token})
    .eq('id', user.id);
}
```

### 4. Gửi Test Notification
Sử dụng Firebase Console hoặc Postman để gửi test notification:

**Firebase Console:**
1. Vào Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Nhập title và message
4. Click "Send test message"
5. Nhập FCM token của device

**Postman/API:**
```bash
POST https://fcm.googleapis.com/v1/projects/staymate-d0282/messages:send
Headers:
  Authorization: Bearer <your-server-key>
Content-Type: application/json

Body:
{
  "message": {
    "token": "<fcm-token>",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test message"
    }
  }
}
```

## 🔧 Tùy chỉnh

### 1. Xử lý Navigation từ Notification
Trong `FirebaseMessagingService._handleMessageOpenedApp()`, thêm logic để navigate đến màn hình cụ thể:

```dart
void _handleMessageOpenedApp(RemoteMessage message) {
  final data = message.data;
  if (data['type'] == 'chat') {
    // Navigate to chat screen
    navigatorKey.currentState?.pushNamed('/chat/${data['roomId']}');
  } else if (data['type'] == 'invoice') {
    // Navigate to invoice screen
    navigatorKey.currentState?.pushNamed('/invoice/${data['invoiceId']}');
  }
}
```

### 2. Hiển thị Local Notification khi App đang mở
Cài đặt `flutter_local_notifications` để hiển thị notification khi app đang mở:

```yaml
dependencies:
  flutter_local_notifications: ^17.0.0
```

### 3. Lưu FCM Token khi User Login
Trong `AuthBloc`, sau khi login thành công, lưu FCM token:

```dart
// Sau khi login thành công
final fcmToken = await firebaseMessagingService.getToken();
if (fcmToken != null) {
  await supabase
    .from('users')
    .update({'fcm_token': fcmToken})
    .eq('id', user.id);
}
```

### 4. Xóa FCM Token khi User Logout
Trong `AuthBloc`, khi logout, xóa FCM token:

```dart
// Khi logout
await firebaseMessagingService.deleteToken();
await supabase
  .from('users')
  .update({'fcm_token': null})
  .eq('id', user.id);
```

## 📱 Testing

### Test trên Device/Emulator
1. Chạy app: `flutter run`
2. Kiểm tra logs để xem FCM token
3. Gửi test notification từ Firebase Console
4. Kiểm tra xem notification có hiển thị không

### Test Background Messages
1. Đóng app hoàn toàn
2. Gửi notification từ Firebase Console
3. Kiểm tra xem notification có hiển thị không
4. Tap vào notification để mở app
5. Kiểm tra xem app có navigate đúng màn hình không

### Test Foreground Messages
1. Mở app
2. Gửi notification từ Firebase Console
3. Kiểm tra logs để xem message có được nhận không
4. Kiểm tra xem có hiển thị notification không (nếu đã cài đặt flutter_local_notifications)

## 🔐 Security

### Lưu FCM Token an toàn
- Lưu FCM token vào database với RLS policies
- Chỉ user mới có thể update FCM token của chính họ
- Xóa FCM token khi user logout

### RLS Policy Example
```sql
CREATE POLICY "Users can update their own FCM token"
ON public.users
FOR UPDATE
TO public
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);
```

## 📝 Notes

- FCM token có thể thay đổi, nên cần lắng nghe `onTokenRefresh` và update token trong database
- Background messages phải được xử lý trong top-level function
- Foreground messages cần hiển thị local notification nếu muốn user thấy
- Notification channel ID phải khớp với AndroidManifest.xml

