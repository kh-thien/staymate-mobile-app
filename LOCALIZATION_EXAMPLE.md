# Ví Dụ: Thay Thế Hardcoded Strings bằng Localization

## Ví Dụ 1: ContractErrorState Widget

### Trước (Hardcoded):

```dart
class ContractErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline),
          Text('Có lỗi xảy ra'),
          Text(message),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh),
            label: Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
```

### Sau (Với Localization):

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

class ContractErrorState extends ConsumerWidget {
  final String message;
  final VoidCallback onRetry;

  const ContractErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline),
          Text(AppLocalizationsHelper.translate('anErrorOccurred', languageCode)),
          Text(message),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh),
            label: Text(AppLocalizationsHelper.translate('tryAgain', languageCode)),
          ),
        ],
      ),
    );
  }
}
```

### Hoặc sử dụng LocalizedText (Đơn giản hơn):

```dart
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

class ContractErrorState extends ConsumerWidget {
  final String message;
  final VoidCallback onRetry;

  const ContractErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline),
          LocalizedText('anErrorOccurred'),
          Text(message),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh),
            label: LocalizedText('tryAgain'),
          ),
        ],
      ),
    );
  }
}
```

## Ví Dụ 2: Invoice Page - Empty State

### Trước:

```dart
if (invoices.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.receipt_long_outlined),
        Text('Không có hoá đơn nào'),
      ],
    ),
  );
}
```

### Sau:

```dart
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

if (invoices.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.receipt_long_outlined),
        LocalizedText('noInvoices'),
      ],
    ),
  );
}
```

## Ví Dụ 3: Report Page - Status Badge

### Trước:

```dart
String _getStatusText() {
  switch (status) {
    case MaintenanceRequestStatus.pending:
      return 'Đang chờ';
    case MaintenanceRequestStatus.approved:
      return 'Đã duyệt';
    case MaintenanceRequestStatus.rejected:
      return 'Đã từ chối';
    case MaintenanceRequestStatus.cancelled:
      return 'Đã hủy';
  }
}
```

### Sau:

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import 'package:stay_mate/core/localization/app_localizations_helper.dart';

class _StatusBadge extends ConsumerWidget {
  final MaintenanceRequestStatus status;

  String _getStatusText(String languageCode) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppLocalizationsHelper.translate('pending', languageCode);
      case MaintenanceRequestStatus.approved:
        return AppLocalizationsHelper.translate('approved', languageCode);
      case MaintenanceRequestStatus.rejected:
        return AppLocalizationsHelper.translate('rejected', languageCode);
      case MaintenanceRequestStatus.cancelled:
        return AppLocalizationsHelper.translate('cancelled', languageCode);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    
    return Text(_getStatusText(languageCode));
  }
}
```

## Checklist: Các Widget Cần Thay Thế

### Ưu tiên cao:
- [ ] Auth widgets (sign in, sign up forms)
- [ ] Error states (contract, invoice, report)
- [ ] Empty states (contract, invoice, report, chat)
- [ ] Status badges (pending, approved, rejected, etc.)
- [ ] Buttons (save, cancel, delete, edit, etc.)
- [ ] Navigation labels (home, contracts, chat, invoices, reports)
- [ ] Profile menu items

### Ưu tiên trung bình:
- [ ] Form labels (email, password, etc.)
- [ ] Validation messages
- [ ] Snackbar messages
- [ ] Dialog titles and messages
- [ ] Time labels (just now, minutes ago, etc.)

### Ưu tiên thấp:
- [ ] Helper text
- [ ] Tooltips
- [ ] Placeholder text

## Lưu Ý

1. **Luôn watch locale**: Khi sử dụng translations, luôn watch `appLocaleProvider` để tự động update
2. **Sử dụng LocalizedText**: Widget này tự động watch locale, dễ sử dụng hơn
3. **Test cả 2 ngôn ngữ**: Sau khi thay thế, test trên cả tiếng Việt và tiếng Anh
4. **Thêm keys mới**: Nếu thiếu translation key, thêm vào `app_localizations_helper.dart`

---

**Bắt đầu với các widget quan trọng nhất trước!** 🚀
