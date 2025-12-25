/// Utility functions for form validation
/// Tuân thủ Apple guidelines về validation
class ValidationUtils {
  /// Email validation pattern - chặt chẽ hơn để đảm bảo format đúng
  /// Apple yêu cầu validation phải chặt chẽ để tránh lỗi
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validate email address
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Let FormField handle required validation
    }

    final trimmedValue = value.trim();

    // Check basic format
    if (!trimmedValue.contains('@')) {
      return 'Email must contain @ symbol';
    }

    // Check for valid email pattern
    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    // Check for common invalid patterns
    if (trimmedValue.startsWith('@') || trimmedValue.endsWith('@')) {
      return 'Please enter a valid email address';
    }

    if (trimmedValue.contains('..') || trimmedValue.contains('@@')) {
      return 'Please enter a valid email address';
    }

    // Check length (reasonable limits)
    if (trimmedValue.length > 254) {
      return 'Email address is too long';
    }

    return null; // Valid
  }

  /// Password validation - Apple khuyến nghị password mạnh
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return null; // Let FormField handle required validation
    }

    // Check minimum length
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Optional: Check for special character (có thể bỏ nếu quá strict)
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password must contain at least one special character';
    // }

    return null; // Valid
  }

  /// Simple password validation (chỉ check độ dài)
  /// Dùng cho trường hợp không muốn quá strict
  static String? validatePasswordSimple(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return null; // Let FormField handle required validation
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null; // Valid
  }

  /// Validate name (full name)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Let FormField handle required validation
    }

    final trimmedValue = value.trim();

    // Check minimum length
    if (trimmedValue.length < 2) {
      return 'Name must be at least 2 characters';
    }

    // Check maximum length
    if (trimmedValue.length > 100) {
      return 'Name is too long';
    }

    // Name validation: Apple doesn't require strict validation
    // Just check basic requirements (length, not empty)
    // Allow all characters to support international names including Vietnamese

    return null; // Valid
  }
}

