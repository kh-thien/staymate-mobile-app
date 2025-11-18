# Hướng Dẫn Đa Ngôn Ngữ (Localization) - StayMate

## Tổng Quan

App StayMate hiện đã hỗ trợ đa ngôn ngữ (tiếng Việt và tiếng Anh). Hệ thống localization sử dụng:
- Flutter Localization (ARB files)
- Riverpod để quản lý state ngôn ngữ
- SharedPreferences để lưu trữ ngôn ngữ đã chọn

## Cấu Trúc Files

```
lib/
  l10n/
    app_en.arb          # Translations tiếng Anh
    app_vi.arb          # Translations tiếng Việt
  core/
    services/
      locale_service.dart      # Service để lưu/load locale
      locale_provider.dart     # Riverpod provider cho locale
```

## Cách Sử Dụng

### 1. Thêm Translation Mới

#### Bước 1: Thêm vào file ARB tiếng Anh (`lib/l10n/app_en.arb`)

```json
{
  "helloWorld": "Hello World",
  "@helloWorld": {
    "description": "A simple greeting"
  },
  "welcomeMessage": "Welcome to StayMate, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

#### Bước 2: Thêm vào file ARB tiếng Việt (`lib/l10n/app_vi.arb`)

```json
{
  "helloWorld": "Xin chào thế giới",
  "welcomeMessage": "Chào mừng đến với StayMate, {name}!",
  "@welcomeMessage": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

#### Bước 3: Generate Localization Files

```bash
flutter gen-l10n
```

Hoặc chạy build để tự động generate:
```bash
flutter build apk
```

### 2. Sử Dụng Translations Trong Code

#### Cách 1: Sử dụng AppLocalizations (Sau khi generate)

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Trong widget
final l10n = AppLocalizations.of(context)!;

Text(l10n.helloWorld)
Text(l10n.welcomeMessage('John'))
```

#### Cách 2: Sử dụng Extension Helper (Khuyến nghị)

Tạo một extension để dễ sử dụng:

```dart
// lib/core/extensions/localization_extensions.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

Sử dụng:

```dart
Text(context.l10n.helloWorld)
Text(context.l10n.welcomeMessage('John'))
```

### 3. Chuyển Đổi Ngôn Ngữ

Người dùng có thể chuyển đổi ngôn ngữ từ:
- **Profile** → **Ngôn ngữ / Language**
- Chọn tiếng Việt hoặc tiếng Anh
- App sẽ tự động reload với ngôn ngữ mới

### 4. Thay Thế Hardcoded Strings

#### Trước (Hardcoded):

```dart
Text('Đăng nhập')
Text('Không có hợp đồng nào')
ElevatedButton(
  onPressed: () {},
  child: Text('Lưu'),
)
```

#### Sau (Với Localization):

```dart
// Sử dụng AppLocalizations (sau khi generate)
Text(context.l10n.signIn)
Text(context.l10n.noContracts)
ElevatedButton(
  onPressed: () {},
  child: Text(context.l10n.save),
)
```

## Các Bước Tiếp Theo

### Bước 1: Generate Localization Files

Hiện tại, các file ARB đã được tạo nhưng chưa generate. Cần chạy:

```bash
flutter gen-l10n
```

Hoặc build app để tự động generate.

### Bước 2: Thay Thế Hardcoded Strings

1. Tìm tất cả hardcoded strings trong app
2. Thêm vào file ARB (cả tiếng Việt và tiếng Anh)
3. Generate localization files
4. Thay thế hardcoded strings bằng `context.l10n.xxx`

### Bước 3: Test

1. Chạy app
2. Vào **Profile** → **Ngôn ngữ / Language**
3. Chuyển đổi giữa tiếng Việt và tiếng Anh
4. Kiểm tra các màn hình đã được dịch đúng chưa

## Ví Dụ: Thay Thế Strings Trong Một Widget

### Trước:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Đăng nhập'),
        Text('Không có dữ liệu'),
        ElevatedButton(
          onPressed: () {},
          child: Text('Lưu'),
        ),
      ],
    );
  }
}
```

### Sau:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Text(l10n.signIn),
        Text(l10n.noContracts),
        ElevatedButton(
          onPressed: () {},
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
```

## Lưu Ý Quan Trọng

1. **Generate Files**: Luôn chạy `flutter gen-l10n` sau khi thêm/sửa ARB files
2. **Placeholders**: Khi sử dụng placeholders (ví dụ: `{name}`), cần khai báo trong `@key` với `placeholders`
3. **Null Safety**: Luôn dùng `!` sau `AppLocalizations.of(context)!` vì chúng ta đã đảm bảo localization được setup
4. **Consistency**: Đảm bảo tất cả keys trong `app_en.arb` và `app_vi.arb` giống nhau
5. **Descriptions**: Thêm `@key` với `description` trong file tiếng Anh để dễ hiểu ý nghĩa

## Troubleshooting

### Lỗi: `AppLocalizations.of(context)` returns null

**Nguyên nhân**: MaterialApp chưa được cấu hình với localization delegates.

**Giải pháp**: Đảm bảo `MaterialApp` có:
```dart
localizationsDelegates: const [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
supportedLocales: LocaleService.getSupportedLocales(),
```

### Lỗi: Translation không thay đổi khi đổi ngôn ngữ

**Nguyên nhân**: Widget không rebuild khi locale thay đổi.

**Giải pháp**: Đảm bảo widget đang watch `localeProvider` hoặc sử dụng `Consumer` widget.

### Lỗi: Missing translation key

**Nguyên nhân**: Key không tồn tại trong ARB file.

**Giải pháp**: 
1. Thêm key vào cả `app_en.arb` và `app_vi.arb`
2. Chạy `flutter gen-l10n`
3. Hot restart app (không phải hot reload)

## Checklist

- [x] Đã tạo file ARB cho tiếng Việt và tiếng Anh
- [x] Đã cấu hình `l10n.yaml`
- [x] Đã cấu hình `pubspec.yaml` với `generate: true`
- [x] Đã tạo `LocaleService` và `LocaleProvider`
- [x] Đã cấu hình `MaterialApp` với localization
- [x] Đã tạo `LanguageSettingsPage`
- [ ] Đã generate localization files (`flutter gen-l10n`)
- [ ] Đã thay thế hardcoded strings trong các widget chính
- [ ] Đã test chuyển đổi ngôn ngữ
- [ ] Đã test trên cả tiếng Việt và tiếng Anh

## Tài Nguyên

- [Flutter Localization Documentation](https://docs.flutter.dev/accessibility-and-localization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle)
- [Riverpod Documentation](https://riverpod.dev/)

---

**Lưu ý**: Hiện tại, hệ thống localization đã được setup nhưng chưa generate files. Bạn cần chạy `flutter gen-l10n` hoặc build app để generate các file localization trước khi sử dụng `AppLocalizations`.
