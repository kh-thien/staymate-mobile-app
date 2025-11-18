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
  String get startAConversationToSeeItHere =>
      'Bắt đầu một cuộc trò chuyện để xem nó ở đây.';

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
}
