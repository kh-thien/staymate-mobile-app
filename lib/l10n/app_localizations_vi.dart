// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'StayMate';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get signInWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get signUpWithGoogle => 'Đăng ký bằng Google';

  @override
  String get signInWithApple => 'Đăng nhập bằng Apple';

  @override
  String get signUpWithApple => 'Đăng ký bằng Apple';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get home => 'Trang chủ';

  @override
  String get contracts => 'Hợp đồng';

  @override
  String get chat => 'Chat';

  @override
  String get invoices => 'Hóa đơn';

  @override
  String get reports => 'Báo cáo và theo dõi sự cố';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get notifications => 'Thông báo';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get noContracts => 'Không có hợp đồng nào';

  @override
  String get noInvoices => 'Không có hoá đơn nào';

  @override
  String get noReports => 'Không có báo cáo nào';

  @override
  String get noChats => 'Không có cuộc trò chuyện nào';

  @override
  String get createReport => 'Tạo báo cáo sự cố';

  @override
  String get reportIssue => 'Báo cáo sự cố';

  @override
  String get maintenanceWork => 'Công việc bảo trì';

  @override
  String get pending => 'Đang chờ';

  @override
  String get approved => 'Đã duyệt';

  @override
  String get rejected => 'Đã từ chối';

  @override
  String get cancelled => 'Đã hủy';

  @override
  String get error => 'Lỗi';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get anErrorOccurred => 'Có lỗi xảy ra';

  @override
  String get loading => 'Đang tải...';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get view => 'Xem';

  @override
  String get send => 'Gửi';

  @override
  String get pay => 'Thanh toán';

  @override
  String get paid => 'Đã thanh toán';

  @override
  String get unpaid => 'Chưa thanh toán';

  @override
  String get online => 'Trực tuyến';

  @override
  String get offline => 'Ngoại tuyến';

  @override
  String get noInternetConnection => 'Không có kết nối internet';

  @override
  String get reconnected => 'Đã kết nối lại';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Thư viện';

  @override
  String get file => 'Tệp';

  @override
  String get justNow => 'Vừa xong';

  @override
  String minutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String hoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String get yesterday => 'Hôm qua';

  @override
  String daysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String get featureComingSoon => 'Tính năng sắp ra mắt';

  @override
  String get refresh => 'Làm mới';

  @override
  String get pullDownToRefresh => 'Kéo xuống để làm mới';

  @override
  String get startAConversationToSeeItHere =>
      'Bắt đầu một cuộc trò chuyện để xem nó ở đây.';

  @override
  String get noConversationsYet => 'Chưa có cuộc trò chuyện nào';

  @override
  String get chatWillAppearWhenYouHaveContract =>
      'Chat sẽ xuất hiện khi bạn có hợp đồng kết nối với chủ nhà. Điều này sẽ tạo cuộc trò chuyện giữa bạn và chủ nhà.';

  @override
  String get pleaseContactLandlord => 'Vui lòng liên hệ chủ nhà';

  @override
  String get noInvoicesFound => 'Không tìm thấy hoá đơn';

  @override
  String get invoicesOfThisCategoryWillAppearHere =>
      'Các hoá đơn trong danh mục này sẽ xuất hiện ở đây.';

  @override
  String get noIssuesToReport => 'Không có sự cố nào';

  @override
  String get yourReportedIssuesWillAppearHere =>
      'Các sự cố bạn báo cáo sẽ xuất hiện ở đây.';

  @override
  String get reconnecting => 'Sự cố kết nối. Đang kết nối lại...';

  @override
  String get personalInfo => 'Thông tin cá nhân';

  @override
  String get account => 'Tài khoản';

  @override
  String get user => 'Người dùng';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get userId => 'ID người dùng';

  @override
  String get created => 'Ngày tạo';

  @override
  String get loginProvider => 'Nhà cung cấp đăng nhập';

  @override
  String memberSince(String date) {
    return 'Thành viên từ $date';
  }

  @override
  String userIdLabel(String userId) {
    return 'ID: $userId';
  }

  @override
  String loginProviderLabel(String provider) {
    return 'Đăng nhập bằng $provider';
  }

  @override
  String get deleteAccount => 'Xóa tài khoản';

  @override
  String get deleteAccountDescription =>
      'Hành động này sẽ xóa vĩnh viễn toàn bộ dữ liệu của bạn và không thể khôi phục.';

  @override
  String get deleteAccountReasonPlaceholder => 'Lý do (không bắt buộc)';

  @override
  String get deleteAccountReasonHint =>
      'Hãy chia sẻ nhanh lý do để chúng tôi cải thiện (không bắt buộc)';

  @override
  String get deleteAccountAcknowledge =>
      'Tôi hiểu rằng tài khoản và dữ liệu của mình sẽ bị xóa vĩnh viễn.';

  @override
  String get deleteAccountConfirm => 'Xóa tài khoản';

  @override
  String get deleteAccountSuccess => 'Tài khoản đã được xóa.';

  @override
  String get deleteAccountFailed =>
      'Không thể xóa tài khoản. Vui lòng thử lại.';

  @override
  String get deleteAccountInProgress => 'Đang xóa tài khoản...';

  @override
  String get deleteAccountDeletingData =>
      'Đang xóa dữ liệu, vui lòng không thao tác';

  @override
  String get deleteAccountLongDescription =>
      'Sau khi xác nhận, chúng tôi sẽ xóa vĩnh viễn hồ sơ, hợp đồng, hóa đơn và lịch sử trò chuyện của bạn theo yêu cầu của Apple.';

  @override
  String get deleteAccountDataWipe =>
      'Tất cả dữ liệu cá nhân và tùy chỉnh sẽ bị xóa ngay lập tức.';

  @override
  String get deleteAccountIrreversible =>
      'Hành động này không thể hoàn tác và bạn sẽ mất quyền truy cập ngay.';

  @override
  String get deleteReasonPrivacy => 'Lo ngại quyền riêng tư';

  @override
  String get deleteReasonNoLongerRenting => 'Không còn thuê nhà với StayMate';

  @override
  String get deleteReasonBuggy => 'Ứng dụng lỗi hoặc không ổn định';

  @override
  String get deleteReasonOther => 'Lý do khác';

  @override
  String get secureLogin => 'Đăng nhập an toàn';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get passwordUpdated => 'Mật khẩu đã được cập nhật';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get passwordChangeNotAvailableForSocialLogin =>
      'Bạn đang đăng nhập bằng tài khoản xã hội (Google/Apple). Để đổi mật khẩu, vui lòng sử dụng tài khoản email.';

  @override
  String get loggedOutSuccessfully => 'Đã đăng xuất thành công';

  @override
  String get selectTheme => 'Chọn giao diện';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get theme => 'Giao diện';

  @override
  String get sendFeedback => 'Gửi phản hồi';

  @override
  String get appInfo => 'Thông tin ứng dụng';

  @override
  String get anErrorOccurredMessage => 'Đã xảy ra lỗi';
}
