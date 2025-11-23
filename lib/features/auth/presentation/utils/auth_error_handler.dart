import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/localization/app_localizations_helper.dart';

class AuthErrorHandler {
  static String _translate(String key, String languageCode) {
    return AppLocalizationsHelper.translate(key, languageCode);
  }

  /// Chuyển đổi error code thành message tiếng Việt từ Supabase AuthException
  static String getErrorMessage(
    supabase.AuthException error,
    String languageCode,
  ) {
    final code = error.statusCode?.toLowerCase();
    final message = error.message.toLowerCase();

    // Xử lý các error codes từ Supabase
    switch (code) {
      case 'invalid_credentials':
      case 'invalid_grant':
        return _translate('authInvalidCredentials', languageCode);

      case 'email_not_confirmed':
        return _translate('authEmailNotConfirmed', languageCode);

      case 'user_not_found':
        return _translate('authUserNotFound', languageCode);

      case 'email_already_registered':
      case 'signup_disabled':
        return _translate('authEmailAlreadyRegistered', languageCode);

      case 'weak_password':
        return _translate('authWeakPassword', languageCode);

      case 'invalid_email':
        return _translate('authInvalidEmail', languageCode);

      case 'too_many_requests':
        return _translate('authTooManyRequests', languageCode);

      case 'network_error':
      case 'network_request_failed':
        return _translate('networkErrorCheckConnection', languageCode);

      case 'user_already_registered':
        return _translate('authEmailAlreadyRegistered', languageCode);

      default:
        // Xử lý message thông thường
        if (message.contains('invalid login credentials')) {
          return _translate('authInvalidCredentials', languageCode);
        } else if (message.contains('email not confirmed')) {
          return _translate('authEmailNotConfirmed', languageCode);
        } else if (message.contains('user not found')) {
          return _translate('authUserNotFound', languageCode);
        } else if (message.contains('already registered') ||
            message.contains('email already exists')) {
          return _translate('authEmailAlreadyRegistered', languageCode);
        } else if (message.contains('weak password') ||
            message.contains('password')) {
          return _translate('authInvalidPassword', languageCode);
        } else if (message.contains('network') ||
            message.contains('connection') ||
            message.contains('timeout')) {
          return _translate('networkErrorCheckConnection', languageCode);
        } else if (message.contains('too many requests') ||
            message.contains('rate limit')) {
          return _translate('authTooManyRequests', languageCode);
        } else if (message.contains('cancelled') ||
            message.contains('canceled')) {
          return _translate('authOperationCancelled', languageCode);
        } else if (message.contains('google')) {
          return _translate('authGoogleSignInFailed', languageCode);
        }

        // Trả về message gốc nếu không match
        return error.message.isNotEmpty
            ? error.message
            : _translate('authUnknownError', languageCode);
    }
  }

  /// Chuyển đổi error message và code thành message tiếng Việt
  static String getErrorMessageFromCode(
    String message,
    String? code,
    String languageCode,
  ) {
    final errorMessage = message.toLowerCase();
    final errorCode = code?.toLowerCase();

    // Xử lý các error codes
    if (errorCode != null) {
      switch (errorCode) {
        case 'invalid_credentials':
        case 'invalid_grant':
          return _translate('authInvalidCredentials', languageCode);

        case 'email_not_confirmed':
          return _translate('authEmailNotConfirmed', languageCode);

        case 'user_not_found':
          return _translate('authUserNotFound', languageCode);

        case 'email_already_registered':
        case 'signup_disabled':
        case 'user_already_registered':
          return _translate('authEmailAlreadyRegistered', languageCode);

        case 'weak_password':
          return _translate('authWeakPassword', languageCode);

        case 'invalid_email':
          return _translate('authInvalidEmail', languageCode);

        case 'too_many_requests':
          return _translate('authTooManyRequests', languageCode);

        case 'network_error':
        case 'network_request_failed':
          return _translate('networkErrorCheckConnection', languageCode);

        case 'google_signin_failed':
          return _translate('authGoogleSignInFailed', languageCode);

        case 'google_signin_cancelled':
          return _translate('authGoogleSignInCancelled', languageCode);

        case 'admin_blocked':
          return _translate('authAdminBlocked', languageCode);

        case 'unknown_error':
          return _translate('authUnknownError', languageCode);

        case 'google_signin_network_error':
          return _translate('networkErrorCheckConnection', languageCode);
      }
    }

    // Xử lý message thông thường
    if (errorMessage.contains('invalid login credentials') ||
        errorMessage.contains('invalid credentials') ||
        errorMessage.contains('invalid_grant')) {
      return _translate('authInvalidCredentials', languageCode);
    } else if (errorMessage.contains('email not confirmed') ||
        errorMessage.contains('email_not_confirmed') ||
        errorMessage.contains('email verification') ||
        errorMessage.contains('verify your email') ||
        errorMessage.contains('confirm your email')) {
      return _translate('authEmailNotConfirmed', languageCode);
    } else if (errorMessage.contains('user not found') ||
        errorMessage.contains('user_not_found')) {
      return _translate('authUserNotFound', languageCode);
    } else if (errorMessage.contains('already registered') ||
        errorMessage.contains('email already exists') ||
        errorMessage.contains('email_already_registered') ||
        errorMessage.contains('user already registered')) {
      return _translate('authEmailAlreadyRegistered', languageCode);
    } else if (errorMessage.contains('weak password') ||
        (errorMessage.contains('password') &&
            errorMessage.contains('weak'))) {
      return _translate('authWeakPassword', languageCode);
    } else if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('socket')) {
      return _translate('networkErrorCheckConnection', languageCode);
    } else if (errorMessage.contains('too many requests') ||
        errorMessage.contains('rate limit')) {
      return _translate('authTooManyRequests', languageCode);
    } else if (errorMessage.contains('cancelled') ||
        errorMessage.contains('canceled')) {
      return _translate('authOperationCancelled', languageCode);
    } else if (errorMessage.contains('google')) {
      if (errorMessage.contains('cancelled') ||
          errorMessage.contains('canceled')) {
        return _translate('authGoogleSignInCancelled', languageCode);
      }
      return _translate('authGoogleSignInFailed', languageCode);
    } else if (errorMessage.contains('id token') ||
        errorMessage.contains('id_token')) {
      return _translate('authGoogleIdTokenError', languageCode);
    }

    // Trả về message gốc nếu không match
    return message.isNotEmpty ? message : _translate('authUnknownError', languageCode);
  }

  /// Chuyển đổi generic error thành message tiếng Việt
  static String getGenericErrorMessage(dynamic error, String languageCode) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      return _translate('networkErrorCheckConnection', languageCode);
    } else if (errorString.contains('timeout')) {
      return _translate('authTimeout', languageCode);
    } else if (errorString.contains('cancelled') ||
        errorString.contains('canceled')) {
      return _translate('authOperationCancelled', languageCode);
    } else if (errorString.contains('permission') ||
        errorString.contains('unauthorized')) {
      return _translate('authPermissionDenied', languageCode);
    } else if (errorString.contains('not found')) {
      return _translate('authDataNotFound', languageCode);
    }

    return _translate('authUnknownError', languageCode);
  }
}

