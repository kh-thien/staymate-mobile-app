# FCM Token Management - Quản lý Token Thông báo

## 📊 Phân tích Database hiện tại

### Bảng `users`
- ✅ Có cột `notification_settings` (jsonb) với default: `{"sms": false, "push": true, "email": true}`
- ❌ **KHÔNG có cột `fcm_token`** - Không thể lưu token trực tiếp
- ❌ **KHÔNG có bảng `user_device_tokens`** - Không thể quản lý nhiều thiết bị

### Vấn đề
1. **Multi-device support**: Một user có thể đăng nhập nhiều thiết bị (điện thoại, máy tính bảng)
2. **Token management**: Mỗi thiết bị có một FCM token riêng
3. **Logout handling**: Khi user đăng xuất, cần xóa token của thiết bị đó
4. **Token refresh**: FCM token có thể thay đổi, cần cập nhật

## 🎯 Giải pháp: Tạo bảng `user_device_tokens`

### Schema đề xuất

```sql
CREATE TABLE public.user_device_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(userid) ON DELETE CASCADE,
    fcm_token TEXT NOT NULL UNIQUE,
    device_id TEXT, -- Optional: Unique device identifier
    device_name TEXT, -- Optional: Device name (e.g., "iPhone 14 Pro", "Samsung Galaxy S23")
    platform TEXT NOT NULL, -- 'ios', 'android', 'web'
    app_version TEXT, -- App version
    is_active BOOLEAN DEFAULT true,
    last_used_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    
    -- Constraints
    CONSTRAINT fcm_token_not_empty CHECK (char_length(fcm_token) > 0),
    CONSTRAINT platform_valid CHECK (platform IN ('ios', 'android', 'web'))
);

-- Indexes
CREATE INDEX idx_user_device_tokens_user_id ON public.user_device_tokens(user_id);
CREATE INDEX idx_user_device_tokens_fcm_token ON public.user_device_tokens(fcm_token);
CREATE INDEX idx_user_device_tokens_active ON public.user_device_tokens(user_id, is_active) WHERE is_active = true;

-- RLS Policies
ALTER TABLE public.user_device_tokens ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own tokens
CREATE POLICY "Users can view their own device tokens"
ON public.user_device_tokens
FOR SELECT
TO public
USING (auth.uid() = user_id);

-- Policy: Users can insert their own tokens
CREATE POLICY "Users can insert their own device tokens"
ON public.user_device_tokens
FOR INSERT
TO public
WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own tokens
CREATE POLICY "Users can update their own device tokens"
ON public.user_device_tokens
FOR UPDATE
TO public
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own tokens
CREATE POLICY "Users can delete their own device tokens"
ON public.user_device_tokens
FOR DELETE
TO public
USING (auth.uid() = user_id);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_user_device_tokens_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_device_tokens_updated_at
BEFORE UPDATE ON public.user_device_tokens
FOR EACH ROW
EXECUTE FUNCTION update_user_device_tokens_updated_at();
```

## 🔄 Logic xử lý

### 1. Khi User đăng nhập

```dart
// 1. Lấy FCM token
final fcmToken = await firebaseMessagingService.getToken();

// 2. Lưu token vào database
if (fcmToken != null && user != null) {
  await supabase
    .from('user_device_tokens')
    .upsert({
      'user_id': user.id,
      'fcm_token': fcmToken,
      'device_id': await getDeviceId(), // Optional
      'device_name': await getDeviceName(), // Optional
      'platform': Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web'),
      'app_version': await getAppVersion(), // Optional
      'is_active': true,
      'last_used_at': DateTime.now().toIso8601String(),
    }, onConflict: 'fcm_token');
}
```

### 2. Khi User đăng xuất

```dart
// 1. Lấy FCM token hiện tại
final fcmToken = await firebaseMessagingService.getToken();

// 2. Xóa token khỏi database
if (fcmToken != null && user != null) {
  await supabase
    .from('user_device_tokens')
    .delete()
    .eq('user_id', user.id)
    .eq('fcm_token', fcmToken);
}

// 3. Xóa token từ Firebase (optional)
await firebaseMessagingService.deleteToken();
```

### 3. Khi FCM Token refresh

```dart
// Lắng nghe token refresh
firebaseMessaging.onTokenRefresh.listen((newToken) async {
  if (user != null) {
    // 1. Lấy token cũ (nếu có)
    final oldToken = await getCurrentFCMToken();
    
    // 2. Update token trong database
    if (oldToken != null) {
      // Update token cũ
      await supabase
        .from('user_device_tokens')
        .update({
          'fcm_token': newToken,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', user.id)
        .eq('fcm_token', oldToken);
    } else {
      // Insert token mới nếu chưa có
      await supabase
        .from('user_device_tokens')
        .insert({
          'user_id': user.id,
          'fcm_token': newToken,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'is_active': true,
        });
    }
  }
});
```

### 4. Khi User đăng nhập nhiều thiết bị

**Scenario**: User A đăng nhập trên:
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
- Server sẽ gửi notification đến **tất cả 3 token**
- User sẽ nhận notification trên **tất cả 3 thiết bị**

### 5. Khi User đăng xuất từ một thiết bị

**Scenario**: User A đăng xuất từ thiết bị 1 (iPhone)

**Hành động**:
1. Xóa token của thiết bị 1 khỏi database
2. Giữ nguyên token của thiết bị 2 và 3

**Kết quả**:
- Thiết bị 1: **KHÔNG** nhận notification nữa
- Thiết bị 2 và 3: **VẪN** nhận notification

### 6. Khi User đăng xuất từ tất cả thiết bị

**Scenario**: User A đăng xuất từ tất cả thiết bị

**Hành động**:
1. Xóa **tất cả token** của user A khỏi database
2. User A **KHÔNG** nhận notification nữa

**Khi user đăng nhập lại**:
- Tạo token mới
- Lưu token mới vào database
- User bắt đầu nhận notification lại

## 📱 Implementation

### Service để quản lý FCM Token

```dart
class FCMTokenService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseMessagingService _fcmService = FirebaseMessagingService();
  
  /// Lưu FCM token khi user đăng nhập
  Future<void> saveToken(String userId) async {
    try {
      final token = await _fcmService.getToken();
      if (token == null) return;
      
      final platform = Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web');
      
      await _supabase
        .from('user_device_tokens')
        .upsert({
          'user_id': userId,
          'fcm_token': token,
          'platform': platform,
          'is_active': true,
          'last_used_at': DateTime.now().toIso8601String(),
        }, onConflict: 'fcm_token');
      
      print('✅ FCM token saved: $token');
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }
  
  /// Xóa FCM token khi user đăng xuất
  Future<void> deleteToken(String userId) async {
    try {
      final token = await _fcmService.getToken();
      if (token == null) return;
      
      await _supabase
        .from('user_device_tokens')
        .delete()
        .eq('user_id', userId)
        .eq('fcm_token', token);
      
      // Xóa token từ Firebase
      await _fcmService.deleteToken();
      
      print('✅ FCM token deleted: $token');
    } catch (e) {
      print('❌ Error deleting FCM token: $e');
    }
  }
  
  /// Cập nhật token khi refresh
  Future<void> updateToken(String userId, String oldToken, String newToken) async {
    try {
      await _supabase
        .from('user_device_tokens')
        .update({
          'fcm_token': newToken,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('fcm_token', oldToken);
      
      print('✅ FCM token updated: $oldToken -> $newToken');
    } catch (e) {
      print('❌ Error updating FCM token: $e');
    }
  }
  
  /// Lấy tất cả token của user (cho server)
  Future<List<String>> getUserTokens(String userId) async {
    try {
      final response = await _supabase
        .from('user_device_tokens')
        .select('fcm_token')
        .eq('user_id', userId)
        .eq('is_active', true);
      
      return (response as List)
        .map((e) => e['fcm_token'] as String)
        .toList();
    } catch (e) {
      print('❌ Error getting user tokens: $e');
      return [];
    }
  }
}
```

### Integration với AuthService

```dart
class AuthService {
  final FCMTokenService _fcmTokenService = FCMTokenService();
  
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    // Lưu FCM token sau khi đăng nhập thành công
    if (response.user != null) {
      await _fcmTokenService.saveToken(response.user!.id);
    }
    
    return response;
  }
  
  Future<void> signOut() async {
    final user = _supabase.auth.currentUser;
    
    // Xóa FCM token trước khi đăng xuất
    if (user != null) {
      await _fcmTokenService.deleteToken(user.id);
    }
    
    await _supabase.auth.signOut();
  }
}
```

## 🚀 Next Steps

1. **Tạo migration** để tạo bảng `user_device_tokens`
2. **Tạo service** `FCMTokenService` để quản lý token
3. **Integrate** với `AuthService` để tự động lưu/xóa token
4. **Update** `FirebaseMessagingService` để lưu token khi refresh
5. **Test** với nhiều thiết bị

## 📝 Notes

- **Token uniqueness**: FCM token là unique, nên dùng `UNIQUE` constraint
- **Multi-device**: Một user có thể có nhiều token (nhiều thiết bị)
- **Token refresh**: Token có thể thay đổi, cần cập nhật trong database
- **Logout**: Chỉ xóa token của thiết bị hiện tại, không xóa token của thiết bị khác
- **Security**: Sử dụng RLS để đảm bảo user chỉ có thể quản lý token của chính họ

