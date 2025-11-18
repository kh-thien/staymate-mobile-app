# Hướng Dẫn Sử Dụng Đa Ngôn Ngữ trong StayMate

## Tổng Quan

App StayMate hiện đã hỗ trợ đa ngôn ngữ (tiếng Việt và tiếng Anh) với hệ thống localization đơn giản và dễ sử dụng.

## Cấu Trúc

### Files đã tạo:
1. **`lib/core/services/locale_service.dart`**: Service để lưu/load locale từ SharedPreferences
2. **`lib/core/services/locale_provider.dart`**: Riverpod provider để quản lý locale state
3. **`lib/core/localization/app_localizations_helper.dart`**: Helper class chứa tất cả translations
4. **`lib/features/profile/presentation/pages/language_settings_page.dart`**: Page để chuyển đổi ngôn ngữ
5. **`lib/l10n/app_en.arb`** và **`lib/l10n/app_vi.arb`**: ARB files (để sử dụng sau này với Flutter localization)

## Cách Sử Dụng

### 1. Sử dụng trong ConsumerWidget hoặc HookConsumerWidget

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch locale để tự động update khi đổi ngôn ngữ
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    
    return Text(
      AppLocalizationsHelper.translate('signIn', languageCode),
    );
  }
}
```

### 2. Sử dụng LocalizedText Widget (Khuyến nghị)

```dart
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

// Sử dụng LocalizedText widget
LocalizedText(
  'signIn',
  style: TextStyle(fontSize: 16),
)
```

### 3. Sử dụng trong StatelessWidget (cần watch locale)

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final locale = ref.watch(appLocaleProvider);
        final languageCode = locale.languageCode;
        
        return Text(
          AppLocalizationsHelper.translate('signIn', languageCode),
        );
      },
    );
  }
}
```

## Ví Dụ: Thay Thế Hardcoded Strings

### Trước:
```dart
Text('Đăng nhập')
Text('Không có hợp đồng nào')
ElevatedButton(
  onPressed: () {},
  child: Text('Lưu'),
)
```

### Sau:
```dart
// Cách 1: Sử dụng LocalizedText
LocalizedText('signIn')
LocalizedText('noContracts')
ElevatedButton(
  onPressed: () {},
  child: LocalizedText('save'),
)

// Cách 2: Sử dụng ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    
    return Column(
      children: [
        Text(AppLocalizationsHelper.translate('signIn', languageCode)),
        Text(AppLocalizationsHelper.translate('noContracts', languageCode)),
        ElevatedButton(
          onPressed: () {},
          child: Text(AppLocalizationsHelper.translate('save', languageCode)),
        ),
      ],
    );
  }
}
```

## Thêm Translation Mới

### Bước 1: Thêm vào `app_localizations_helper.dart`

Trong class `AppLocalizationsHelper`, thêm key mới vào cả 2 maps (`'vi'` và `'en'`):

```dart
static const Map<String, Map<String, String>> _translations = {
  'vi': {
    // ... existing translations
    'myNewKey': 'Bản dịch tiếng Việt',
  },
  'en': {
    // ... existing translations
    'myNewKey': 'English translation',
  },
};
```

### Bước 2: Sử dụng trong code

```dart
LocalizedText('myNewKey')
// hoặc
Text(AppLocalizationsHelper.translate('myNewKey', languageCode))
```

## Chuyển Đổi Ngôn Ngữ

Người dùng có thể chuyển đổi ngôn ngữ từ:
1. Mở app
2. Vào **Profile** (icon người dùng)
3. Chọn **Ngôn ngữ / Language**
4. Chọn **Tiếng Việt** hoặc **English**
5. App sẽ tự động reload với ngôn ngữ mới

## Các Translation Keys Hiện Có

### Auth
- `signIn`, `signUp`, `signInWithGoogle`, `signUpWithGoogle`
- `email`, `password`, `confirmPassword`, `logout`

### Navigation
- `home`, `contracts`, `chat`, `invoices`, `reports`, `profile`
- `notifications`, `settings`, `language`

### Empty States
- `noContracts`, `noInvoices`, `noReports`, `noChats`

### Status
- `pending`, `approved`, `rejected`, `cancelled`
- `paid`, `unpaid`

### Common
- `error`, `tryAgain`, `anErrorOccurred`, `loading`
- `save`, `cancel`, `delete`, `edit`, `view`, `send`, `pay`

### Connectivity
- `online`, `offline`, `noInternetConnection`, `reconnected`

### Media
- `camera`, `gallery`, `file`

### Time
- `justNow`, `yesterday`

## Lưu Ý Quan Trọng

1. **Luôn watch `appLocaleProvider`**: Khi sử dụng translations, luôn watch `appLocaleProvider` để tự động update khi đổi ngôn ngữ
2. **Sử dụng LocalizedText**: Widget `LocalizedText` tự động watch locale, dễ sử dụng hơn
3. **Hot Restart**: Sau khi đổi ngôn ngữ, app sẽ tự động rebuild. Nếu không, cần hot restart
4. **Consistency**: Đảm bảo tất cả keys có trong cả 2 ngôn ngữ (vi và en)

## Next Steps

1. Thay thế tất cả hardcoded strings trong app bằng translations
2. Thêm các translation keys còn thiếu
3. Test trên cả tiếng Việt và tiếng Anh
4. (Tùy chọn) Migrate sang Flutter localization với ARB files nếu cần nhiều tính năng hơn

## Troubleshooting

### Translation không thay đổi khi đổi ngôn ngữ

**Nguyên nhân**: Widget không watch `appLocaleProvider`.

**Giải pháp**: Sử dụng `LocalizedText` widget hoặc wrap widget với `Consumer` và watch `appLocaleProvider`.

### Missing translation key

**Nguyên nhân**: Key chưa được thêm vào `app_localizations_helper.dart`.

**Giải pháp**: Thêm key vào cả 2 maps (`'vi'` và `'en'`) trong `AppLocalizationsHelper`.

---

**Chúc bạn thành công!** 🎉
