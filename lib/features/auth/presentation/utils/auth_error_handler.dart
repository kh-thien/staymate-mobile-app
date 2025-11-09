import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthErrorHandler {
  /// Chuyển đổi error code thành message tiếng Việt từ Supabase AuthException
  static String getErrorMessage(supabase.AuthException error) {
    final code = error.statusCode;
    final message = error.message.toLowerCase();

    // Xử lý các error codes từ Supabase
    switch (code) {
      case 'invalid_credentials':
      case 'invalid_grant':
        return 'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';

      case 'email_not_confirmed':
        return 'Email chưa được xác nhận. Vui lòng kiểm tra hộp thư của bạn.';

      case 'user_not_found':
        return 'Tài khoản không tồn tại. Vui lòng kiểm tra lại email.';

      case 'email_already_registered':
      case 'signup_disabled':
        return 'Email này đã được đăng ký. Vui lòng đăng nhập hoặc sử dụng email khác.';

      case 'weak_password':
        return 'Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn (ít nhất 6 ký tự).';

      case 'invalid_email':
        return 'Email không hợp lệ. Vui lòng kiểm tra lại.';

      case 'too_many_requests':
        return 'Quá nhiều yêu cầu. Vui lòng thử lại sau vài phút.';

      case 'network_error':
      case 'network_request_failed':
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';

      case 'user_already_registered':
        return 'Tài khoản đã tồn tại. Vui lòng đăng nhập.';

      default:
        // Xử lý message thông thường
        if (message.contains('invalid login credentials')) {
          return 'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';
        } else if (message.contains('email not confirmed')) {
          return 'Email chưa được xác nhận. Vui lòng kiểm tra hộp thư của bạn.';
        } else if (message.contains('user not found')) {
          return 'Tài khoản không tồn tại. Vui lòng kiểm tra lại email.';
        } else if (message.contains('already registered') ||
            message.contains('email already exists')) {
          return 'Email này đã được đăng ký. Vui lòng đăng nhập.';
        } else if (message.contains('weak password') ||
            message.contains('password')) {
          return 'Mật khẩu không hợp lệ. Vui lòng thử lại.';
        } else if (message.contains('network') ||
            message.contains('connection') ||
            message.contains('timeout')) {
          return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
        } else if (message.contains('too many requests') ||
            message.contains('rate limit')) {
          return 'Quá nhiều yêu cầu. Vui lòng thử lại sau vài phút.';
        } else if (message.contains('cancelled') ||
            message.contains('canceled')) {
          return 'Thao tác đã bị hủy.';
        } else if (message.contains('google')) {
          return 'Đăng nhập với Google thất bại. Vui lòng thử lại.';
        }

        // Trả về message gốc nếu không match
        return error.message.isNotEmpty
            ? error.message
            : 'Đã xảy ra lỗi. Vui lòng thử lại.';
    }
  }

  /// Chuyển đổi error message và code thành message tiếng Việt
  static String getErrorMessageFromCode(String message, String? code) {
    final errorMessage = message.toLowerCase();
    final errorCode = code?.toLowerCase();

    // Xử lý các error codes
    if (errorCode != null) {
      switch (errorCode) {
        case 'invalid_credentials':
        case 'invalid_grant':
          return 'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';

        case 'email_not_confirmed':
          return 'Email chưa được xác nhận. Vui lòng kiểm tra hộp thư của bạn.';

        case 'user_not_found':
          return 'Tài khoản không tồn tại. Vui lòng kiểm tra lại email.';

        case 'email_already_registered':
        case 'signup_disabled':
        case 'user_already_registered':
          return 'Email này đã được đăng ký. Vui lòng đăng nhập hoặc sử dụng email khác.';

        case 'weak_password':
          return 'Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn (ít nhất 6 ký tự).';

        case 'invalid_email':
          return 'Email không hợp lệ. Vui lòng kiểm tra lại.';

        case 'too_many_requests':
          return 'Quá nhiều yêu cầu. Vui lòng thử lại sau vài phút.';

        case 'network_error':
        case 'network_request_failed':
          return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';

        case 'google_signin_failed':
          return 'Đăng nhập với Google thất bại. Vui lòng thử lại.';

        case 'google_signin_cancelled':
          return 'Đăng nhập với Google đã bị hủy.';

        case 'admin_blocked':
          return 'Ứng dụng này dành riêng cho người thuê, tính năng admin sẽ được phát triển sau';

        case 'unknown_error':
          return 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
      }
    }

    // Xử lý message thông thường
    if (errorMessage.contains('invalid login credentials') ||
        errorMessage.contains('invalid credentials') ||
        errorMessage.contains('invalid_grant')) {
      return 'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';
    } else if (errorMessage.contains('email not confirmed') ||
        errorMessage.contains('email_not_confirmed') ||
        errorMessage.contains('email verification') ||
        errorMessage.contains('verify your email') ||
        errorMessage.contains('confirm your email')) {
      return 'Email chưa được xác nhận. Vui lòng kiểm tra hộp thư và xác nhận email trước khi đăng nhập.';
    } else if (errorMessage.contains('user not found') ||
        errorMessage.contains('user_not_found')) {
      return 'Tài khoản không tồn tại. Vui lòng kiểm tra lại email.';
    } else if (errorMessage.contains('already registered') ||
        errorMessage.contains('email already exists') ||
        errorMessage.contains('email_already_registered') ||
        errorMessage.contains('user already registered')) {
      return 'Email này đã được đăng ký. Vui lòng đăng nhập.';
    } else if (errorMessage.contains('weak password') ||
        (errorMessage.contains('password') &&
            errorMessage.contains('weak'))) {
      return 'Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn.';
    } else if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('socket')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
    } else if (errorMessage.contains('too many requests') ||
        errorMessage.contains('rate limit')) {
      return 'Quá nhiều yêu cầu. Vui lòng thử lại sau vài phút.';
    } else if (errorMessage.contains('cancelled') ||
        errorMessage.contains('canceled')) {
      return 'Thao tác đã bị hủy.';
    } else if (errorMessage.contains('google')) {
      if (errorMessage.contains('cancelled') ||
          errorMessage.contains('canceled')) {
        return 'Đăng nhập với Google đã bị hủy.';
      }
      return 'Đăng nhập với Google thất bại. Vui lòng thử lại.';
    } else if (errorMessage.contains('id token') ||
        errorMessage.contains('id_token')) {
      return 'Không thể lấy thông tin từ Google. Vui lòng thử lại.';
    }

    // Trả về message gốc nếu không match
    return message.isNotEmpty ? message : 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }

  /// Chuyển đổi generic error thành message tiếng Việt
  static String getGenericErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
    } else if (errorString.contains('timeout')) {
      return 'Yêu cầu quá thời gian chờ. Vui lòng thử lại.';
    } else if (errorString.contains('cancelled') ||
        errorString.contains('canceled')) {
      return 'Thao tác đã bị hủy.';
    } else if (errorString.contains('permission') ||
        errorString.contains('unauthorized')) {
      return 'Bạn không có quyền thực hiện thao tác này.';
    } else if (errorString.contains('not found')) {
      return 'Không tìm thấy dữ liệu. Vui lòng thử lại.';
    }

    return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }
}

