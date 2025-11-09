# FCM Token Management - Tóm tắt Implementation

## ✅ Đã hoàn thành

### 1. Database Schema
- ✅ **Bảng `user_device_tokens`** đã được tạo trong Supabase
- ✅ **RLS Policies** đã được cấu hình để bảo mật
- ✅ **Indexes** đã được tạo để tối ưu query
- ✅ **Constraints** đã được thiết lập (UNIQUE fcm_token, CHECK platform)

### 2. Services
- ✅ **FCMTokenService**: Service để quản lý FCM token (lưu, xóa, cập nhật)
- ✅ **FirebaseMessagingService**: Đã tích hợp với FCMTokenService
- ✅ **AuthService**: Đã tích hợp với FCMTokenService để tự động lưu/xóa token

### 3. Logic Flow

#### Khi User đăng nhập:
1. User đăng nhập thành công (email/password hoặc Google)
2. `AuthService` gọi `FCMTokenService.saveToken(userId)`
3. `FCMTokenService` lấy FCM token từ Firebase
4. Lưu token vào bảng `user_device_tokens` với:
   - `user_id`: ID của user
   - `fcm_token`: FCM token từ Firebase
   - `platform`: 'ios' hoặc 'android'
   - `is_active`: true
   - `last_used_at`: Thời gian hiện tại

#### Khi User đăng xuất:
1. User bấm đăng xuất
2. `AuthService` gọi `FCMTokenService.deleteToken(userId)`
3. `FCMTokenService` lấy FCM token hiện tại
4. Xóa token khỏi bảng `user_device_tokens` (chỉ token của thiết bị này)
5. User không nhận notification nữa trên thiết bị này

#### Khi FCM Token refresh:
1. Firebase tự động refresh token (khi app reinstall, token expire, etc.)
2. `FirebaseMessagingService` lắng nghe `onTokenRefresh`
3. Gọi `FCMTokenService.updateToken(userId, oldToken, newToken)`
4. Cập nhật token trong database
5. User vẫn nhận notification bình thường

#### Khi User đăng nhập nhiều thiết bị:
**Ví dụ**: User A đăng nhập trên:
- Thiết bị 1: iPhone (token: `token1`)
- Thiết bị 2: Android (token: `token2`)
- Thiết bị 3: iPad (token: `token3`)

**Database sẽ có 3 records**:
```
| user_id | fcm_token | platform | is_active |
|---------|-----------|----------|-----------|
| user_a  | token1    | ios      | true      |
| user_a  | token2    | android  | true      |
| user_a  | token3    | ios      | true      |
```

**Khi gửi notification**:
- Server sẽ query tất cả token của user A: `SELECT fcm_token FROM user_device_tokens WHERE user_id = 'user_a' AND is_active = true`
- Gửi notification đến **tất cả 3 token**
- User sẽ nhận notification trên **tất cả 3 thiết bị**

#### Khi User đăng xuất từ một thiết bị:
**Ví dụ**: User A đăng xuất từ thiết bị 1 (iPhone)

**Hành động**:
1. Xóa token của thiết bị 1 khỏi database
2. Giữ nguyên token của thiết bị 2 và 3

**Kết quả**:
- Thiết bị 1: **KHÔNG** nhận notification nữa
- Thiết bị 2 và 3: **VẪN** nhận notification

#### Khi User đăng xuất từ tất cả thiết bị:
**Ví dụ**: User A đăng xuất từ tất cả thiết bị

**Hành động**:
1. Xóa **tất cả token** của user A khỏi database (mỗi thiết bị xóa token của chính nó)
2. User A **KHÔNG** nhận notification nữa

**Khi user đăng nhập lại**:
- Tạo token mới
- Lưu token mới vào database
- User bắt đầu nhận notification lại

## 🔍 Kiểm tra Database

### Xem tất cả token của một user:
```sql
SELECT * FROM user_device_tokens 
WHERE user_id = 'user_id_here' 
ORDER BY created_at DESC;
```

### Xem token active:
```sql
SELECT * FROM user_device_tokens 
WHERE user_id = 'user_id_here' 
  AND is_active = true;
```

### Xem tất cả token (admin):
```sql
SELECT 
    udt.*,
    u.email,
    u.full_name
FROM user_device_tokens udt
JOIN users u ON u.userid = udt.user_id
ORDER BY udt.created_at DESC;
```

## 🚀 Cách sử dụng

### 1. Lưu token khi đăng nhập (Đã tự động)
```dart
// Đã được tích hợp trong AuthService
// Không cần gọi thủ công
```

### 2. Xóa token khi đăng xuất (Đã tự động)
```dart
// Đã được tích hợp trong AuthService
// Không cần gọi thủ công
```

### 3. Lấy token của user (cho server):
```dart
final fcmTokenService = FCMTokenService();
final tokens = await fcmTokenService.getUserTokens(userId);
// Returns: List<String> of FCM tokens
```

## 📝 Notes

### 1. Token Uniqueness
- FCM token là **unique** (mỗi thiết bị có một token duy nhất)
- Nếu token đã tồn tại với user khác, sẽ xóa token cũ và tạo mới cho user hiện tại

### 2. Multi-device Support
- Một user có thể có **nhiều token** (nhiều thiết bị)
- Khi gửi notification, server cần gửi đến **tất cả token** của user

### 3. Token Refresh
- FCM token có thể thay đổi (khi app reinstall, token expire, etc.)
- Hệ thống tự động cập nhật token khi refresh

### 4. Security
- RLS Policies đảm bảo user chỉ có thể quản lý token của chính họ
- Token được lưu an toàn trong database

### 5. Logout Behavior
- Khi user đăng xuất, chỉ xóa token của **thiết bị hiện tại**
- Token của các thiết bị khác vẫn được giữ nguyên
- User vẫn nhận notification trên các thiết bị khác

## 🔧 Testing

### Test lưu token:
1. Đăng nhập vào app
2. Kiểm tra logs: `💾 FCM TOKEN SAVED TO DATABASE: <token>`
3. Kiểm tra database: `SELECT * FROM user_device_tokens WHERE user_id = '<user_id>';`

### Test xóa token:
1. Đăng xuất khỏi app
2. Kiểm tra logs: `🗑️ FCM TOKEN DELETED FROM DATABASE: <token>`
3. Kiểm tra database: Token đã bị xóa

### Test multi-device:
1. Đăng nhập trên thiết bị 1
2. Đăng nhập trên thiết bị 2 (cùng user)
3. Kiểm tra database: Có 2 token cho cùng một user
4. Gửi notification: Cả 2 thiết bị đều nhận

### Test token refresh:
1. Đăng nhập vào app
2. Token sẽ tự động refresh (nếu cần)
3. Kiểm tra logs: `🔄 FCM TOKEN UPDATED IN DATABASE: <old_token> -> <new_token>`
4. Kiểm tra database: Token đã được cập nhật

## 📊 Database Schema

```sql
CREATE TABLE public.user_device_tokens (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(userid),
    fcm_token TEXT NOT NULL UNIQUE,
    device_id TEXT,
    device_name TEXT,
    platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
    app_version TEXT,
    is_active BOOLEAN DEFAULT true,
    last_used_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
```

## 🎯 Next Steps

1. ✅ **Database**: Đã tạo bảng `user_device_tokens`
2. ✅ **Services**: Đã tạo `FCMTokenService` và tích hợp với `AuthService`
3. ✅ **Auto-save**: Token tự động lưu khi đăng nhập
4. ✅ **Auto-delete**: Token tự động xóa khi đăng xuất
5. ✅ **Token refresh**: Token tự động cập nhật khi refresh
6. ⏳ **Server-side**: Cần tạo API/function để gửi notification đến user
7. ⏳ **Testing**: Test với nhiều thiết bị và scenarios khác nhau

## 🔐 Security Considerations

1. **RLS Policies**: Đảm bảo user chỉ có thể quản lý token của chính họ
2. **Token Storage**: Token được lưu an toàn trong database
3. **Token Deletion**: Token được xóa khi user đăng xuất
4. **Token Refresh**: Token được cập nhật tự động khi refresh

## 📱 Platform Support

- ✅ **iOS**: Đã hỗ trợ
- ✅ **Android**: Đã hỗ trợ
- ⏳ **Web**: Chưa test (có thể cần điều chỉnh)

