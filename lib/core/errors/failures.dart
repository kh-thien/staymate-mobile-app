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
  const NetworkFailure(super.message, {super.code});
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

// Auth Failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure([super.message = 'Token has expired']);
}

// Validation Failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure(super.message, {this.errors, super.code});
}

// Data Failures
class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message, {super.code});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}
