# Stay Mate

<div align="center">

![Stay Mate Logo](lib/core/assets/images/logo_staymate.png)

**Ứng dụng quản lý thuê trọ dành cho người thuê** | **Rental management app for tenants**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📑 Navigation | Điều hướng

<div align="center">

### 🌐 Choose Language | Chọn ngôn ngữ

**[🇬🇧 English](#english)** • **[🇻🇳 Tiếng Việt](#tiếng-việt)**

</div>

### Quick Links | Liên kết nhanh

<details>
<summary><b>🇻🇳 Tiếng Việt</b></summary>

- [Giới thiệu](#-giới-thiệu)
- [Tính năng chính](#-tính-năng-chính)
- [Bắt đầu](#-bắt-đầu)
- [Kiến trúc](#️-kiến-trúc)
- [Dependencies](#-dependencies-chính)
- [Đa ngôn ngữ](#-đa-ngôn-ngữ)
- [License](#-license)
- [Đóng góp](#-đóng-góp)
- [Liên hệ](#-liên-hệ)

</details>

<details>
<summary><b>🇬🇧 English</b></summary>

- [Introduction](#-introduction)
- [Key Features](#-key-features)
- [Getting Started](#-getting-started)
- [Architecture](#️-architecture)
- [Key Dependencies](#-key-dependencies)
- [Multi-language Support](#-multi-language-support)
- [License](#-license-1)
- [Contributing](#-contributing)
- [Contact](#-contact)

</details>

---

## Tiếng Việt

### 📱 Giới thiệu

Stay Mate là ứng dụng quản lý thuê trọ được thiết kế dành riêng cho người thuê. Ứng dụng giúp bạn quản lý hợp đồng thuê, theo dõi hóa đơn, báo cáo sự cố và giao tiếp với chủ nhà một cách dễ dàng.

### ✨ Tính năng chính

- 🏠 **Trang chủ**: Tổng quan nhanh về hợp đồng, hóa đơn sắp đến và các sự cố bảo trì
- 📄 **Hợp đồng**: Xem danh sách hợp đồng, trạng thái ký kết và chi tiết (tiền thuê, đặt cọc, chu kỳ thanh toán, tệp đính kèm)
- 💰 **Hóa đơn**: Xem hóa đơn, chi tiết từng khoản, trạng thái thanh toán và hướng dẫn chuyển khoản ngân hàng
- 🛠️ **Báo cáo**: Tạo/gửi báo cáo bảo trì kèm hình ảnh, theo dõi tiến độ và xem lịch sử
- 💬 **Chat**: Nhắn tin real-time với chủ nhà
- 👤 **Hồ sơ**: Thông tin cá nhân, cài đặt tài khoản, chọn ngôn ngữ (VI/EN), và thông tin ứng dụng

### 🚀 Bắt đầu

#### Yêu cầu

- Flutter SDK 3.x trở lên
- Dart 3.x trở lên
- Android Studio / VS Code với Flutter extensions
- Supabase account (cho backend)

#### Cài đặt

```bash
# Clone repository
git clone https://github.com/kh-thien/staymate-mobile-app.git
cd staymate-mobile-app

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run
```

#### Cấu hình

1. Tạo file `.env` trong thư mục root:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

2. Cấu hình Firebase (cho notifications):
   - Thêm `google-services.json` (Android) vào `android/app/`
   - Thêm `GoogleService-Info.plist` (iOS) vào `ios/Runner/`

### 🏗️ Kiến trúc

Ứng dụng sử dụng Clean Architecture với các layer:

- **Presentation**: UI, Widgets, BLoC/Riverpod
- **Domain**: Entities, Use Cases, Repositories (interfaces)
- **Data**: Models, Data Sources, Repository implementations

### 📦 Dependencies chính

- `flutter_bloc` / `riverpod` - State management
- `supabase_flutter` - Backend & Authentication
- `go_router` - Navigation
- `freezed` - Immutable data classes
- `flutter_hooks` - React-like hooks
- `firebase_messaging` - Push notifications

### 🌐 Đa ngôn ngữ

Ứng dụng hỗ trợ 2 ngôn ngữ:
- 🇻🇳 Tiếng Việt
- 🇬🇧 English

Người dùng có thể chuyển đổi ngôn ngữ trong Settings > Language.

### 📄 License

MIT License - xem file [LICENSE](LICENSE) để biết thêm chi tiết.

### 👥 Đóng góp

Mọi đóng góp đều được chào đón! Vui lòng tạo Pull Request hoặc Issue.

### 📧 Liên hệ

- Email: staymate.home@gmail.com
- Privacy Policy: [https://kh-thien.github.io/privacy-policy-staymate-mobile-app/](https://kh-thien.github.io/privacy-policy-staymate-mobile-app/)
- Terms of Service: [https://kh-thien.github.io/terms-of-service-staymate/](https://kh-thien.github.io/terms-of-service-staymate/)

---

<div align="center">

⬆️ [Back to Top](#stay-mate) • [Switch to English](#english) ⬆️

</div>

---

## English

### 📱 Introduction

Stay Mate is a rental property management application designed exclusively for tenants. The app helps you manage rental contracts, track invoices, report issues, and communicate with your landlord easily.

### ✨ Key Features

- 🏠 **Home**: Quick overview of contracts, upcoming invoices, and open maintenance issues
- 📄 **Contracts**: View contract list, signing status, and details (rent, deposit, payment period, attached files)
- 💰 **Invoices**: View invoices, itemized details, payment status, and bank transfer instructions
- 🛠️ **Reports**: Create/submit maintenance reports with photos, track progress, and view history
- 💬 **Chat**: Real-time messaging with landlords
- 👤 **Profile**: Personal information, account settings, language selection (VI/EN), and app information

### 🚀 Getting Started

#### Requirements

- Flutter SDK 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code with Flutter extensions
- Supabase account (for backend)

#### Installation

```bash
# Clone repository
git clone https://github.com/kh-thien/staymate-mobile-app.git
cd staymate-mobile-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

#### Configuration

1. Create `.env` file in root directory:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

2. Configure Firebase (for notifications):
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`

### 🏗️ Architecture

The app uses Clean Architecture with the following layers:

- **Presentation**: UI, Widgets, BLoC/Riverpod
- **Domain**: Entities, Use Cases, Repositories (interfaces)
- **Data**: Models, Data Sources, Repository implementations

### 📦 Key Dependencies

- `flutter_bloc` / `riverpod` - State management
- `supabase_flutter` - Backend & Authentication
- `go_router` - Navigation
- `freezed` - Immutable data classes
- `flutter_hooks` - React-like hooks
- `firebase_messaging` - Push notifications

### 🌐 Multi-language Support

The app supports 2 languages:
- 🇻🇳 Vietnamese
- 🇬🇧 English

Users can switch languages in Settings > Language.

### 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

### 👥 Contributing

Contributions are welcome! Please create a Pull Request or Issue.

### 📧 Contact

- Email: staymate.home@gmail.com
- Privacy Policy: [https://kh-thien.github.io/privacy-policy-staymate-mobile-app/](https://kh-thien.github.io/privacy-policy-staymate-mobile-app/)
- Terms of Service: [https://kh-thien.github.io/terms-of-service-staymate/](https://kh-thien.github.io/terms-of-service-staymate/)

---

<div align="center">

⬆️ [Back to Top](#stay-mate) • [Switch to Tiếng Việt](#tiếng-việt) ⬆️

</div>

---

<div align="center">

Made with ❤️ by [Khac Thien Nguyen](https://github.com/kh-thien)

</div>
