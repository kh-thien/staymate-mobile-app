# Phân tích Authentication và Đề xuất Giải pháp

## Vấn đề hiện tại

### 1. Router không có Authentication Guard
- **Vị trí**: `lib/core/router/app_router.dart`
- **Vấn đề**: Tất cả routes đều có thể truy cập mà không cần đăng nhập
- **Hậu quả**: User chưa đăng nhập vẫn có thể truy cập các features và sẽ gặp lỗi

### 2. Features không check authentication state
- **Contract**: `lib/features/contract/presentation/pages/contract_page.dart`
  - Check `AuthService.currentUser` nhưng không có fallback
  - Sẽ crash khi `user == null`
  
- **Invoice**: `lib/features/invoice/data/datasources/invoice_remote_datasource.dart`
  - Check `_supabase.auth.currentUser` nhưng throw exception khi null
  - Không có UI để prompt login
  
- **Chat**: `lib/features/chat/data/datasources/chat_remote_datasource.dart`
  - Check `_supabase.auth.currentUser` nhưng throw exception khi null
  
- **Report/Maintenance**: `lib/features/report/data/datasources/maintenance_request_remote_datasource.dart`
  - Check `_supabase.auth.currentUser` nhưng throw exception khi null

### 3. Không có UI để prompt login
- Chỉ có `SignInBottomSheet` được hiển thị khi click vào profile icon
- Không có automatic redirect hoặc prompt khi user chưa đăng nhập

## Giải pháp đề xuất

### Giải pháp 1: Thêm Authentication Guard vào Router (Khuyến nghị)

#### 1.1. Tạo AuthGuard widget
```dart
// lib/core/guards/auth_guard.dart
class AuthGuard extends StatelessWidget {
  final Widget child;
  
  const AuthGuard({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return child;
        } else if (state is AuthUnauthenticated) {
          return _LoginPromptScreen();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
```

#### 1.2. Cập nhật Router
- Wrap các protected routes với `AuthGuard`
- Hoặc sử dụng `GoRouter` redirect callback

### Giải pháp 2: Kiểm tra Auth trong từng Feature

#### 2.1. Tạo ProtectedPage wrapper
```dart
// lib/core/widgets/protected_page.dart
class ProtectedPage extends StatelessWidget {
  final Widget child;
  final Widget? loginPrompt;
  
  const ProtectedPage({
    required this.child,
    this.loginPrompt,
  });
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return child;
        } else {
          return loginPrompt ?? _DefaultLoginPrompt();
        }
      },
    );
  }
}
```

#### 2.2. Wrap các pages với ProtectedPage
- ContractPage
- InvoicePage
- ChatListPage
- ReportPage

### Giải pháp 3: Tạo Login Prompt Screen

#### 3.1. Tạo LoginPromptScreen widget
- Hiển thị message "Vui lòng đăng nhập để sử dụng tính năng này"
- Button "Đăng nhập" mở SignInBottomSheet
- Có thể hiển thị ở giữa màn hình hoặc full screen

## Implementation Plan

### Bước 1: Tạo AuthGuard widget
1. Tạo file `lib/core/guards/auth_guard.dart`
2. Tạo `LoginPromptScreen` widget
3. Test với một route

### Bước 2: Cập nhật Router
1. Thêm `redirect` callback vào GoRouter
2. Hoặc wrap ShellRoute với AuthGuard
3. Test navigation flow

### Bước 3: Cập nhật các Features
1. Wrap các protected pages với AuthGuard
2. Test từng feature khi chưa đăng nhập
3. Đảm bảo không có crash

### Bước 4: Tạo Empty States
1. Tạo empty state với login prompt cho mỗi feature
2. Test UX flow

## Lưu ý

1. **HomePage**: Có thể cho phép truy cập mà không cần đăng nhập (public)
2. **Other routes**: Cần đăng nhập để truy cập
3. **Error handling**: Cần handle các trường hợp:
   - User chưa đăng nhập
   - Session expired
   - Network error

## Files cần tạo/sửa

### Files mới:
1. `lib/core/guards/auth_guard.dart`
2. `lib/core/widgets/login_prompt_screen.dart`
3. `lib/core/widgets/protected_page.dart`

### Files cần sửa:
1. `lib/core/router/app_router.dart` - Thêm auth guard
2. `lib/features/contract/presentation/pages/contract_page.dart` - Wrap với ProtectedPage
3. `lib/features/invoice/presentation/pages/invoice_page.dart` - Wrap với ProtectedPage
4. `lib/features/chat/presentation/pages/chat_list_page.dart` - Wrap với ProtectedPage
5. `lib/features/report/presentation/pages/report_page.dart` - Wrap với ProtectedPage

