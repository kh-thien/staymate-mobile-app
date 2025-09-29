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
  NetworkException(String message, {String? code}) : super(message, code: code);
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(String message, {this.statusCode, String? code})
    : super(message, code: code);

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class CacheException extends AppException {
  CacheException(String message, {String? code}) : super(message, code: code);
}

// Auth Exceptions
class AuthException extends AppException {
  AuthException(String message, {String? code}) : super(message, code: code);
}

class UnauthorizedException extends AuthException {
  UnauthorizedException([String message = 'Unauthorized access'])
    : super(message);
}

class TokenExpiredException extends AuthException {
  TokenExpiredException([String message = 'Token has expired'])
    : super(message);
}

// Validation Exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException(String message, {this.errors, String? code})
    : super(message, code: code);
}

// Data Exceptions
class DataParsingException extends AppException {
  DataParsingException(String message, {String? code})
    : super(message, code: code);
}

class DatabaseException extends AppException {
  DatabaseException(String message, {String? code})
    : super(message, code: code);
}
