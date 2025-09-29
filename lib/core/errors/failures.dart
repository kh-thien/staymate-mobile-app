// Base Failure
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (Code: $code)' : ''}';
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? code})
    : super(message, code: code);
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(String message, {this.statusCode, String? code})
    : super(message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {String? code})
    : super(message, code: code);
}

// Auth Failures
class AuthFailure extends Failure {
  const AuthFailure(String message, {String? code})
    : super(message, code: code);
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure([String message = 'Unauthorized access'])
    : super(message);
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure([String message = 'Token has expired'])
    : super(message);
}

// Validation Failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure(String message, {this.errors, String? code})
    : super(message, code: code);
}

// Data Failures
class DataParsingFailure extends Failure {
  const DataParsingFailure(String message, {String? code})
    : super(message, code: code);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message, {String? code})
    : super(message, code: code);
}
