# FCM Token Management - Q&A

## ❓ Câu hỏi thường gặp

### 1. **Khi user đăng nhập xong thì lưu token ở đâu?**

**Trả lời:**
- Token được lưu vào bảng `user_device_tokens` trong Supabase
- Tự động lưu khi user đăng nhập thành công (email/password hoặc Google)
- Service: `FCMTokenService.saveToken(userId)` được gọi tự động từ `AuthService`

**Code flow:**
```
User đăng nhập 
  → AuthService.signInWithEmail() 
    → FCMTokenService.saveToken(userId)
      → Lấy FCM token từ Firebase
      → Lưu vào database: user_device_tokens
```

### 2. **Khi đăng xuất sẽ như thế nào?**

**Trả lời:**
- Token của thiết bị hiện tại được xóa khỏi database
- Chỉ xóa token của thiết bị đang đăng xuất
- Token của các thiết bị khác vẫn được giữ nguyên
- Service: `FCMTokenService.deleteToken(userId)` được gọi tự động từ `AuthService`

**Code flow:**
```
User đăng xuất
  → AuthService.signOut()
    → FCMTokenService.deleteToken(userId)
      → Lấy FCM token hiện tại
      → Xóa token khỏi database
      → User không nhận notification nữa trên thiết bị này
```

### 3. **Ví dụ khi user đó còn tài khoản trong app, thì có thông báo tới máy không?**

**Trả lời:**
- **CÓ** - Nếu user đã đăng nhập và token đã được lưu trong database
- Server sẽ query token từ database: `SELECT fcm_token FROM user_device_tokens WHERE user_id = 'user_id' AND is_active = true`
- Gửi notification đến tất cả token của user
- User sẽ nhận notification trên tất cả thiết bị đã đăng nhập

**Ví dụ:**
```
User A đăng nhập trên:
  - Thiết bị 1: iPhone (token1)
  - Thiết bị 2: Android (token2)

Database có 2 token:
  - user_id: A, fcm_token: token1, is_active: true
  - user_id: A, fcm_token: token2, is_active: true

Khi gửi notification:
  - Server gửi đến token1 → Thiết bị 1 nhận
  - Server gửi đến token2 → Thiết bị 2 nhận
```

### 4. **Ví dụ user đăng nhập nhiều máy thì sao?**

**Trả lời:**
- Mỗi thiết bị có một FCM token riêng
- Mỗi token được lưu như một record riêng trong database
- User có thể đăng nhập trên nhiều thiết bị cùng lúc
- Mỗi thiết bị sẽ nhận notification độc lập

**Ví dụ:**
```
User A đăng nhập trên:
  - Thiết bị 1: iPhone (token1) → Record 1
  - Thiết bị 2: Android (token2) → Record 2
  - Thiết bị 3: iPad (token3) → Record 3

Database có 3 records:
  | id  | user_id | fcm_token | platform | is_active |
  |-----|---------|-----------|----------|-----------|
  | 1   | user_a  | token1    | ios      | true      |
  | 2   | user_a  | token2    | android  | true      |
  | 3   | user_a  | token3    | ios      | true      |

Khi gửi notification:
  - Server query: SELECT fcm_token FROM user_device_tokens WHERE user_id = 'user_a' AND is_active = true
  - Kết quả: [token1, token2, token3]
  - Server gửi notification đến cả 3 token
  - User nhận notification trên cả 3 thiết bị
```

### 5. **Nếu user đăng xuất thì liệu có thông báo nữa không?**

**Trả lời:**
- **KHÔNG** - Nếu user đăng xuất từ thiết bị đó
- Token của thiết bị đó bị xóa khỏi database
- Server không tìm thấy token → Không gửi notification đến thiết bị đó
- **NHƯNG** - Nếu user đăng nhập trên thiết bị khác, thiết bị đó vẫn nhận notification

**Ví dụ:**
```
User A đăng nhập trên:
  - Thiết bị 1: iPhone (token1)
  - Thiết bị 2: Android (token2)

User A đăng xuất từ thiết bị 1:
  - Token1 bị xóa khỏi database
  - Token2 vẫn còn trong database

Khi gửi notification:
  - Server query: SELECT fcm_token FROM user_device_tokens WHERE user_id = 'user_a' AND is_active = true
  - Kết quả: [token2]
  - Server gửi notification đến token2
  - Thiết bị 1: KHÔNG nhận notification
  - Thiết bị 2: VẪN nhận notification
```

### 6. **Nếu user đăng xuất từ tất cả thiết bị thì sao?**

**Trả lời:**
- Tất cả token của user bị xóa khỏi database
- User **KHÔNG** nhận notification nữa
- Khi user đăng nhập lại, token mới được tạo và lưu
- User bắt đầu nhận notification lại

**Ví dụ:**
```
User A đăng nhập trên:
  - Thiết bị 1: iPhone (token1)
  - Thiết bị 2: Android (token2)

User A đăng xuất từ cả 2 thiết bị:
  - Token1 bị xóa
  - Token2 bị xóa
  - Database không còn token nào của user A

Khi gửi notification:
  - Server query: SELECT fcm_token FROM user_device_tokens WHERE user_id = 'user_a' AND is_active = true
  - Kết quả: []
  - Server không gửi notification (vì không có token)

User A đăng nhập lại trên thiết bị 1:
  - Token mới được tạo (token3)
  - Token3 được lưu vào database
  - User A bắt đầu nhận notification lại
```

### 7. **FCM token có thay đổi không?**

**Trả lời:**
- **CÓ** - FCM token có thể thay đổi trong các trường hợp:
  - App được reinstall
  - App được restore trên thiết bị mới
  - Token expire (hiếm khi xảy ra)
  - Firebase refresh token

**Xử lý:**
- `FirebaseMessagingService` lắng nghe `onTokenRefresh`
- Khi token refresh, tự động cập nhật token trong database
- User vẫn nhận notification bình thường

**Code flow:**
```
FCM token refresh
  → FirebaseMessagingService.onTokenRefresh
    → FCMTokenService.updateToken(userId, oldToken, newToken)
      → Update token trong database
      → User vẫn nhận notification
```

### 8. **Làm sao để gửi notification đến user?**

**Trả lời:**
- Server cần query token từ database
- Gửi notification đến tất cả token của user
- Sử dụng Firebase Admin SDK hoặc FCM API

**Ví dụ (Server-side):**
```javascript
// 1. Query token từ database
const tokens = await supabase
  .from('user_device_tokens')
  .select('fcm_token')
  .eq('user_id', userId)
  .eq('is_active', true);

// 2. Gửi notification đến tất cả token
for (const token of tokens) {
  await admin.messaging().send({
    token: token.fcm_token,
    notification: {
      title: 'Thông báo mới',
      body: 'Bạn có tin nhắn mới',
    },
    data: {
      type: 'chat',
      roomId: 'room_id',
    },
  });
}
```

## 📊 Database Schema

### Bảng `user_device_tokens`

```sql
CREATE TABLE public.user_device_tokens (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(userid),
    fcm_token TEXT NOT NULL UNIQUE,
    device_id TEXT,
    device_name TEXT,
    platform TEXT NOT NULL, -- 'ios', 'android', 'web'
    app_version TEXT,
    is_active BOOLEAN DEFAULT true,
    last_used_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
```

### RLS Policies

- ✅ Users chỉ có thể xem token của chính họ
- ✅ Users chỉ có thể insert token của chính họ
- ✅ Users chỉ có thể update token của chính họ
- ✅ Users chỉ có thể delete token của chính họ

## 🔄 Flow Diagram

### Login Flow
```
User Login
  ↓
AuthService.signInWithEmail/Google
  ↓
FCMTokenService.saveToken(userId)
  ↓
Get FCM Token from Firebase
  ↓
Save to Database (user_device_tokens)
  ↓
Token saved ✅
```

### Logout Flow
```
User Logout
  ↓
AuthService.signOut
  ↓
FCMTokenService.deleteToken(userId)
  ↓
Get Current FCM Token
  ↓
Delete from Database (user_device_tokens)
  ↓
Token deleted ✅
```

### Token Refresh Flow
```
FCM Token Refresh
  ↓
FirebaseMessagingService.onTokenRefresh
  ↓
FCMTokenService.updateToken(userId, oldToken, newToken)
  ↓
Update in Database (user_device_tokens)
  ↓
Token updated ✅
```

### Multi-device Flow
```
User Login on Device 1
  ↓
Token1 saved to Database
  ↓
User Login on Device 2
  ↓
Token2 saved to Database
  ↓
Database has 2 tokens for user
  ↓
Send Notification
  ↓
Server queries all tokens
  ↓
Send to Token1 and Token2
  ↓
User receives on both devices ✅
```

## 🎯 Tóm tắt

1. **Token được lưu ở đâu?** → Bảng `user_device_tokens` trong Supabase
2. **Khi nào lưu token?** → Khi user đăng nhập thành công
3. **Khi nào xóa token?** → Khi user đăng xuất
4. **Multi-device?** → Mỗi thiết bị có token riêng, tất cả đều nhận notification
5. **Đăng xuất?** → Chỉ xóa token của thiết bị đó, thiết bị khác vẫn nhận notification
6. **Token refresh?** → Tự động cập nhật trong database

