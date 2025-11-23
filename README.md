# Stay Mate

<div align="center">

<img src="lib/core/assets/images/logo_staymate.png" alt="Stay Mate Logo" width="120" height="120">

**Rental management app for tenants**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**[🇻🇳 Tiếng Việt](README_VI.md)** • **[🇬🇧 English](#)**

</div>

---

## 📱 Introduction

Stay Mate is a rental property management application designed exclusively for tenants. The app helps you manage rental contracts, track invoices, report issues, and communicate with your landlord easily.

## ✨ Key Features

- 🏠 **Home**: Quick overview of contracts, upcoming invoices, and open maintenance issues
- 📄 **Contracts**: View contract list, signing status, and details (rent, deposit, payment period, attached files)
- 💰 **Invoices**: View invoices, itemized details, payment status, and bank transfer instructions
- 🛠️ **Reports**: Create/submit maintenance reports with photos, track progress, and view history
- 💬 **Chat**: Real-time messaging with landlords
- 👤 **Profile**: Personal information, account settings, language selection (VI/EN), and app information

## 🚀 Getting Started

### Requirements

- Flutter SDK 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code with Flutter extensions
- Supabase account (for backend)

### Installation

```bash
# Clone repository
git clone https://github.com/kh-thien/staymate-mobile-app.git
cd staymate-mobile-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configuration

1. Create `.env` file in root directory:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

2. Configure Firebase (for notifications):
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`

## 🏗️ Architecture

The app uses Clean Architecture with the following layers:

- **Presentation**: UI, Widgets, BLoC/Riverpod
- **Domain**: Entities, Use Cases, Repositories (interfaces)
- **Data**: Models, Data Sources, Repository implementations

## 📦 Key Dependencies

- `flutter_bloc` / `riverpod` - State management
- `supabase_flutter` - Backend & Authentication
- `go_router` - Navigation
- `freezed` - Immutable data classes
- `flutter_hooks` - React-like hooks
- `firebase_messaging` - Push notifications

## 🌐 Multi-language Support

The app supports 2 languages:
- 🇻🇳 Vietnamese
- 🇬🇧 English

Users can switch languages in Settings > Language.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 👥 Contributing

Contributions are welcome! Please create a Pull Request or Issue.

## 📧 Contact

- Email: staymate.home@gmail.com
- Privacy Policy: [https://kh-thien.github.io/privacy-policy-staymate-mobile-app/](https://kh-thien.github.io/privacy-policy-staymate-mobile-app/)
- Terms of Service: [https://kh-thien.github.io/terms-of-service-staymate/](https://kh-thien.github.io/terms-of-service-staymate/)

---

<div align="center">

Made with ❤️ by [Khac Thien Nguyen](https://github.com/kh-thien)

**[🇻🇳 Read in Vietnamese](README_VI.md)**

</div>
