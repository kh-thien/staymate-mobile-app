# StayMate Mobile App - Flutter Architecture

## Cấu trúc dự án Feature-based

Dự án này sử dụng **Clean Architecture** và **Feature-based folder structure** để dễ dàng quản lý và mở rộng.

## 📁 Cấu trúc thư mục

```
lib/
├── core/                     # Lõi ứng dụng (dùng chung)
│   ├── constants/           # Hằng số, màu sắc, styles
│   │   ├── app_constants.dart
│   │   └── app_styles.dart
│   ├── errors/             # Xử lý lỗi
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/           # Cấu hình mạng
│   ├── services/          # Services chung
│   ├── theme/            # Theme ứng dụng
│   │   └── app_theme.dart
│   └── utils/            # Tiện ích
│       └── helpers.dart
├── features/             # Các tính năng chính
│   ├── auth/            # Tính năng đăng nhập/đăng ký
│   │   ├── data/        # Data layer
│   │   │   ├── datasources/  # API, local storage
│   │   │   ├── models/       # Data models
│   │   │   └── repositories/ # Repository implementation
│   │   ├── domain/      # Business logic layer
│   │   │   ├── entities/     # Business entities
│   │   │   ├── repositories/ # Repository contracts
│   │   │   └── usecases/     # Use cases
│   │   └── presentation/ # UI layer
│   │       ├── blocs/       # State management (BLoC)
│   │       ├── pages/       # Screens
│   │       └── widgets/     # Feature-specific widgets
│   ├── home/            # Trang chủ
│   ├── booking/         # Đặt phòng
│   └── profile/         # Hồ sơ người dùng
├── shared/              # Components dùng chung
│   ├── widgets/         # Widget tái sử dụng
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   └── app_widgets.dart
│   ├── models/          # Models chung
│   └── extensions/      # Extensions
│       └── extensions.dart
└── main.dart           # Entry point
```

## 🏗️ Clean Architecture Layers

### 1. **Data Layer** (`data/`)
- **DataSources**: Giao tiếp với API, database, local storage
- **Models**: Data models với JSON serialization
- **Repositories**: Implement business repository interfaces

### 2. **Domain Layer** (`domain/`)
- **Entities**: Pure Dart objects, business models
- **Repositories**: Abstract contracts
- **UseCases**: Business logic, use cases

### 3. **Presentation Layer** (`presentation/`)
- **BLoC**: State management
- **Pages**: UI screens
- **Widgets**: Feature-specific widgets

## 🚀 Cách sử dụng

### Thêm tính năng mới

1. **Tạo folder cho feature mới** trong `lib/features/`
2. **Tạo cấu trúc 3 layers**: `data/`, `domain/`, `presentation/`
3. **Implement theo thứ tự**: Domain → Data → Presentation

### Ví dụ: Tạo feature "Booking"

```bash
lib/features/booking/
├── data/
│   ├── datasources/
│   │   ├── booking_local_datasource.dart
│   │   └── booking_remote_datasource.dart
│   ├── models/
│   │   └── booking_model.dart
│   └── repositories/
│       └── booking_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── booking.dart
│   ├── repositories/
│   │   └── booking_repository.dart
│   └── usecases/
│       ├── create_booking.dart
│       ├── get_bookings.dart
│       └── cancel_booking.dart
└── presentation/
    ├── blocs/
    │   ├── booking_bloc.dart
    │   ├── booking_event.dart
    │   └── booking_state.dart
    ├── pages/
    │   ├── booking_list_page.dart
    │   └── create_booking_page.dart
    └── widgets/
        ├── booking_card.dart
        └── booking_form.dart
```

## 📦 Dependencies cần thiết

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  
  # HTTP Client
  dio: ^5.3.2
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # JSON Annotation
  json_annotation: ^4.8.1
  
  # Get It (Dependency Injection)
  get_it: ^7.6.4
  
  # Either (Functional Programming)
  dartz: ^0.10.1

dev_dependencies:
  # Build Runner
  build_runner: ^2.4.7
  
  # JSON Serializable
  json_serializable: ^6.7.1
  
  # Testing
  mockito: ^5.4.2
```

## 🔧 Quy tắc và Best Practices

### 1. **Naming Conventions**
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/Functions: `camelCase`
- Constants: `UPPER_CASE`

### 2. **Import Rules**
- Dart packages trước
- Flutter packages sau
- Internal imports cuối cùng
- Sử dụng relative imports cho cùng feature

### 3. **State Management**
- Sử dụng BLoC pattern
- Mỗi feature có BLoC riêng
- Tránh global state không cần thiết

### 4. **Error Handling**
- Sử dụng `Either<Failure, Success>` pattern
- Custom exceptions cho từng layer
- User-friendly error messages

## 🎨 Theme và Styling

- Colors, sizes, text styles được define trong `core/constants/`
- Sử dụng Material Design 3
- Dark mode support
- Responsive design

## 🧪 Testing Strategy

```
test/
├── unit/           # Unit tests
├── widget/         # Widget tests
└── integration/    # Integration tests
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🤝 Contributing

1. Tạo feature branch từ `develop`
2. Follow coding conventions
3. Write tests
4. Create pull request

---

**Happy Coding! 🚀**