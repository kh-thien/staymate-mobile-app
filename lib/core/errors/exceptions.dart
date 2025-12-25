// Base Exception
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Network Exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, {this.statusCode, super.code});

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class CacheException extends AppException {
  CacheException(super.message, {super.code});
}

// Auth Exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

class UnauthorizedException extends AuthException {
  UnauthorizedException([super.message = 'Unauthorized access']);
}

class TokenExpiredException extends AuthException {
  TokenExpiredException([super.message = 'Token has expired']);
}

// Validation Exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException(super.message, {this.errors, super.code});
}

// Data Exceptions
class DataParsingException extends AppException {
  DataParsingException(super.message, {super.code});
}

class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code});
}
