import 'package:flutter/material.dart';
import '../services/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Helper class để dễ dàng sử dụng translations trong app
/// Sử dụng với Riverpod để tự động update khi locale thay đổi
class AppLocalizationsHelper {
  static const Map<String, Map<String, String>> _translations = {
    'vi': {
      // Auth
      'signIn': 'Đăng nhập',
      'signUp': 'Đăng ký',
      'signInWithGoogle': 'Đăng nhập bằng Google',
      'signUpWithGoogle': 'Đăng ký bằng Google',
      'signInWithApple': 'Đăng nhập bằng Apple',
      'signUpWithApple': 'Đăng ký bằng Apple',
      'email': 'Email',
      'password': 'Mật khẩu',
      'confirmPassword': 'Xác nhận mật khẩu',
      'fullName': 'Họ và tên',
      'logout': 'Đăng xuất',

      // Validation messages
      'pleaseEnterEmail': 'Vui lòng nhập email',
      'invalidEmail': 'Email không hợp lệ',
      'pleaseEnterPassword': 'Vui lòng nhập mật khẩu',
      'pleaseEnterName': 'Vui lòng nhập họ và tên',
      'passwordMinLength': 'Mật khẩu phải có ít nhất 6 ký tự',
      'pleaseCheckInternetConnection': 'Vui lòng kiểm tra lại kết nối mạng',
      'pleaseFillAllFields': 'Vui lòng nhập đầy đủ thông tin',
      'authInvalidCredentials':
          'Email hoặc mật khẩu không đúng. Vui lòng thử lại.',
      'authEmailNotConfirmed':
          'Email chưa được xác nhận. Vui lòng kiểm tra hộp thư của bạn.',
      'authUserNotFound':
          'Tài khoản không tồn tại. Vui lòng kiểm tra lại email.',
      'authEmailAlreadyRegistered':
          'Email này đã được đăng ký. Vui lòng đăng nhập hoặc sử dụng email khác.',
      'authWeakPassword':
          'Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn.',
      'authInvalidEmail': 'Email không hợp lệ. Vui lòng kiểm tra lại.',
      'authTooManyRequests':
          'Quá nhiều yêu cầu. Vui lòng thử lại sau vài phút.',
      'authInvalidPassword': 'Mật khẩu không hợp lệ. Vui lòng thử lại.',
      'authOperationCancelled': 'Thao tác đã bị hủy.',
      'authGoogleSignInFailed':
          'Đăng nhập với Google thất bại. Vui lòng thử lại.',
      'authGoogleSignInCancelled': 'Đăng nhập với Google đã bị hủy.',
      'authAppleSignInFailed':
          'Đăng nhập với Apple thất bại. Vui lòng thử lại.',
      'authAppleSignInCancelled': 'Đăng nhập với Apple đã bị hủy.',
      'authAppleIdTokenError':
          'Không thể lấy thông tin từ Apple. Vui lòng thử lại.',
      'authAppleAudienceError':
          'Lỗi cấu hình Apple Sign-In: Service ID không khớp. Vui lòng kiểm tra Service ID trong Supabase Dashboard (phải là com.staymate.mobile.web, không phải com.staymate.mobile).',
      'authAdminBlocked':
          'Ứng dụng này dành riêng cho người thuê, tính năng admin sẽ được phát triển sau.',
      'authUnknownError': 'Đã xảy ra lỗi. Vui lòng thử lại.',
      'authServerError': 'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.',
      'authTimeout': 'Yêu cầu quá thời gian chờ. Vui lòng thử lại.',
      'authPermissionDenied': 'Bạn không có quyền thực hiện thao tác này.',
      'authDataNotFound': 'Không tìm thấy dữ liệu. Vui lòng thử lại.',
      'authGoogleIdTokenError':
          'Không thể lấy thông tin từ Google. Vui lòng thử lại.',
      'authSignUpEmailConfirmationRequired':
          'Đăng ký thành công! Vui lòng kiểm tra email và xác nhận tài khoản trước khi đăng nhập.',
      'signUpAccountTitle': 'Đăng ký tài khoản',
      'signUpAccountSubtitle': 'Tạo tài khoản mới để sử dụng StayMate',
      'signUpSuccessShort': 'Đăng ký thành công!',
      'signUpErrorPrefix': 'Lỗi đăng ký',
      'orLabel': 'hoặc',
      'alreadyHaveAccount': 'Đã có tài khoản? ',

      // Navigation
      'home': 'Trang chủ',
      'contracts': 'Hợp đồng',
      'chat': 'Tin nhắn',
      'invoices': 'Hóa đơn',
      'reports': 'Báo cáo và theo dõi sự cố',
      'profile': 'Hồ sơ',
      'notifications': 'Thông báo',
      'settings': 'Cài đặt',
      'language': 'Ngôn ngữ',
      'checkingNotificationStatus': 'Đang kiểm tra...',
      'notificationTypes': 'Loại thông báo',
      'notificationTypesDescription':
          'Nhận thông báo về các cập nhật quan trọng:',
      'notificationEnabled': 'Đã bật',
      'notificationDisabled': 'Đã tắt',
      'notificationNotGranted': 'Chưa cấp quyền',
      'notificationTypeNewMessage': 'Tin nhắn mới',
      'notificationTypeNewMessageDesc': 'Nhận thông báo khi có tin nhắn mới',
      'notificationTypeContractUpdate': 'Cập nhật hợp đồng',
      'notificationTypeContractUpdateDesc': 'Thông báo về thay đổi hợp đồng',
      'notificationTypeInvoice': 'Thông báo hóa đơn',
      'notificationTypeInvoiceDesc': 'Nhắc nhở về hóa đơn cần thanh toán',
      'notificationTypeNewReport': 'Báo cáo mới',
      'notificationTypeNewReportDesc': 'Cập nhật về báo cáo và sự cố',
      'openSystemSettings': 'Mở cài đặt hệ thống',
      'manageInSettings': 'Quản lý trong cài đặt',
      'notificationPermissionDeniedMessage':
          'Để bật thông báo, vui lòng mở Cài đặt hệ thống và bật quyền thông báo cho ứng dụng.',
      'notificationEnableMessage':
          'Bật công tắc phía trên để nhận thông báo từ ứng dụng.',
      'notificationEnabledSuccess': 'Đã bật thông báo thành công!',
      'notificationPermissionDenied': 'Quyền thông báo bị từ chối',
      'errorCheckingStatus': 'Lỗi khi kiểm tra trạng thái',
      'errorRequestingPermission': 'Lỗi khi yêu cầu quyền',
      'cannotOpenSystemSettings': 'Không thể mở cài đặt hệ thống',
      'theme': 'Giao diện',
      'themeLight': 'Sáng',
      'themeDark': 'Tối',
      'themeSystem': 'Theo hệ thống',
      'selectTheme': 'Chọn giao diện',

      // Language
      'vietnamese': 'Tiếng Việt',
      'english': 'Tiếng Anh',

      // Empty states
      'noContracts': 'Không có hợp đồng nào',
      'noContractsFound': 'Không tìm thấy hợp đồng nào',
      'noInvoices': 'Không có hoá đơn nào',
      'noInvoicesFound': 'Chưa có hoá đơn nào',
      'invoicesOfThisCategoryWillAppearHere':
          'Các hoá đơn của mục này sẽ xuất hiện ở đây khi có.',
      'noReports': 'Không có báo cáo nào',
      'noIssuesToReport': 'Chưa có báo cáo sự cố nào',
      'yourReportedIssuesWillAppearHere':
          'Các sự cố bạn báo cáo sẽ hiển thị ở đây khi được tạo.',
      'noChats': 'Không có cuộc trò chuyện nào',
      'chatStatusFailed': 'Gửi thất bại',
      'chatStatusRetry': 'Gửi lại',
      'chatStatusSending': 'Đang gửi',
      'chatStatusDelivered': 'Đã nhận',
      'chatWillAppearWhenYouHaveContract':
          'Chat sẽ xuất hiện khi bạn có hợp đồng kết nối với chủ nhà. Điều này sẽ tạo cuộc trò chuyện giữa bạn và chủ nhà.',
      'pleaseContactLandlord': 'Vui lòng liên hệ chủ nhà',
      'startAConversationToSeeItHere':
          'Hãy bắt đầu cuộc trò chuyện để xem nội dung tại đây.',
      'noNotifications': 'Chưa có thông báo nào',
      'noMaintenanceWork': 'Chưa có công việc bảo trì',
      'noIssues': 'Chưa có sự cố gì',
      'pullDownToRefresh': 'Kéo xuống để làm mới',

      // Reports
      'createReport': 'Tạo báo cáo sự cố',
      'reportIssue': 'Báo cáo sự cố',
      'reportHeaderSubtitle': 'Vui lòng điền đầy đủ thông tin',
      'maintenanceWork': 'Công việc bảo trì',
      'issue': 'Sự cố',
      'issueDescription': 'Mô tả sự cố',
      'issueDescriptionHint': 'Nhập chi tiết sự cố cần báo cáo...',
      'issueImagesOptional': 'Ảnh minh họa (tùy chọn)',
      'allGood': 'Yên ổn',
      'maintenanceWorkWillShowHere': 'Các công việc bảo trì sẽ hiển thị ở đây',
      'fromYourReport': 'Từ báo cáo của bạn',
      'viewOnlyCannotEdit':
          'Chỉ xem - Bạn không thể chỉnh sửa công việc bảo trì',
      'hasImage': 'Có ảnh',
      'selectPropertyAndRoom': 'Vui lòng chọn bất động sản và phòng',
      'selectPropertyPlaceholder': 'Chọn bất động sản',
      'selectPropertyFirst': 'Chọn bất động sản trước',
      'selectRoomPlaceholder': 'Chọn phòng',
      'pleaseSelectProperty': 'Vui lòng chọn bất động sản',
      'pleaseSelectRoom': 'Vui lòng chọn phòng',
      'pleaseEnterIssueDescription': 'Vui lòng nhập mô tả sự cố',
      'descriptionMinCharacters': 'Mô tả phải có ít nhất {count} ký tự',
      'unnamedRoom': 'Phòng không tên',
      'maxImagesHint': 'Tối đa {count} ảnh',
      'imagePickerError': 'Lỗi chọn ảnh: {error}',
      'addPhoto': 'Thêm ảnh',
      'add': 'Thêm',
      'reportSubmitSuccess': 'Gửi báo cáo thành công, vui lòng chờ duyệt',
      'submitting': 'Đang gửi...',
      'submitReport': 'Gửi báo cáo',

      // Status
      'pending': 'Đang chờ',
      'approved': 'Đã duyệt',
      'rejected': 'Đã từ chối',
      'cancelled': 'Đã hủy',
      'paid': 'Đã thanh toán',
      'unpaid': 'Chưa thanh toán',
      'processing': 'Chờ duyệt',
      'overdue': 'Quá hạn',
      'partiallyPaid': 'TT 1 phần',
      'all': 'Tất cả',
      'paidShort': 'Đã TT',
      'unpaidShort': 'Chưa TT',
      'waitingApproval': 'Chờ duyệt',
      'waitingProcess': 'Chờ xử lý',
      'inProgress': 'Đang xử lý',
      'completed': 'Hoàn thành',

      // Common
      'error': 'Lỗi',
      'tryAgain': 'Thử lại',
      'anErrorOccurred': 'Có lỗi xảy ra',
      'loading': 'Đang tải...',
      'save': 'Lưu',
      'cancel': 'Hủy',
      'delete': 'Xóa',
      'edit': 'Chỉnh sửa',
      'view': 'Xem',
      'send': 'Gửi',
      'pay': 'Thanh toán',
      'paymentMethodBankTransfer': 'Chuyển khoản ngân hàng',
      'paymentMethodQrCode': 'Quét mã QR',
      'paymentMethodMomo': 'Ví MoMo',
      'paymentMethodZaloPay': 'ZaloPay',
      'paymentMethodCard': 'Thẻ tín dụng/Ghi nợ',
      'paymentMethodComingSoon': 'Sắp ra mắt',

      // Connectivity
      'online': 'Trực tuyến',
      'offline': 'Ngoại tuyến',
      'noInternetConnection': 'Không có kết nối internet',
      'reconnected': 'Đã kết nối lại',
      'networkError': 'Lỗi kết nối mạng',
      'networkErrorTryAgain': 'Lỗi kết nối mạng. Vui lòng thử lại.',
      'networkErrorCheckConnection':
          'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.',

      // Media
      'camera': 'Camera',
      'gallery': 'Thư viện',
      'file': 'Tệp',

      // Time
      'justNow': 'Vừa xong',
      'yesterday': 'Hôm qua',
      'minutesAgo': '{minutes} phút trước',
      'hoursAgo': '{hours} giờ trước',
      'daysAgo': '{days} ngày trước',

      // User
      'user': 'Người dùng',
      'userId': 'ID người dùng',
      'userIdLabel': 'ID: {userId}',
      'loginProvider': 'Nhà cung cấp đăng nhập',
      'loginProviderLabel': 'Đăng nhập bằng {provider}',
      'deleteAccount': 'Xóa tài khoản',
      'deleteAccountDescription':
          'Hành động này sẽ xóa vĩnh viễn toàn bộ dữ liệu của bạn và không thể khôi phục.',
      'deleteAccountReasonPlaceholder': 'Lý do (không bắt buộc)',
      'deleteAccountReasonHint':
          'Hãy chia sẻ nhanh lý do để chúng tôi cải thiện (không bắt buộc).',
      'deleteAccountAcknowledge':
          'Tôi hiểu rằng tài khoản và dữ liệu của mình sẽ bị xóa vĩnh viễn.',
      'deleteAccountConfirm': 'Xóa tài khoản',
      'deleteAccountSuccess': 'Tài khoản đã được xóa.',
      'deleteAccountFailed': 'Không thể xóa tài khoản. Vui lòng thử lại.',
      'deleteAccountInProgress': 'Đang xóa tài khoản...',
      'deleteAccountDeletingData': 'Đang xóa dữ liệu, vui lòng không thao tác',
      'deleteAccountLongDescription':
          'Sau khi xác nhận, chúng tôi sẽ xóa vĩnh viễn hồ sơ, hợp đồng, hóa đơn và lịch sử trò chuyện của bạn theo yêu cầu của Apple.',
      'deleteAccountDataWipe':
          'Tất cả dữ liệu cá nhân và tùy chỉnh sẽ bị xóa ngay lập tức.',
      'deleteAccountIrreversible':
          'Hành động này không thể hoàn tác và bạn sẽ mất quyền truy cập ngay.',
      'deleteReasonPrivacy': 'Lo ngại quyền riêng tư',
      'deleteReasonNoLongerRenting': 'Không còn thuê nhà với StayMate',
      'deleteReasonBuggy': 'Ứng dụng lỗi hoặc không ổn định',
      'deleteReasonOther': 'Lý do khác',
      'secureLogin': 'Đăng nhập an toàn',
      'memberSince': 'Thành viên từ {date}',

      // Auth Header
      'appDescription': 'Ứng dụng theo dõi phòng trọ tiện lợi',
      'appDescriptionSubtitle': 'dành riêng cho người thuê',

      // Success messages
      'signInSuccess': 'Đăng nhập thành công!',
      'signUpSuccess': 'Đăng ký thành công! Chào mừng đến với StayMate!',
      'paymentRecorded':
          'Đã ghi nhận thanh toán. Chủ nhà sẽ xác nhận trong thời gian sớm nhất.',

      // Contracts
      'contractList': 'Danh sách hợp đồng',
      'contractListCount': 'Danh sách hợp đồng ({count})',
      'noContractsYet': 'Chưa có hợp đồng nào',
      'contactLandlordToCreateContract': 'Liên hệ với chủ nhà để tạo hợp đồng',
      'contractStatus': 'Trạng thái hợp đồng',
      'contractCount': 'Số hợp đồng',
      'youHaveContracts': 'Bạn có {count} hợp đồng thuê trọ',
      'noContractYet': 'Chưa có hợp đồng',
      'contactLandlordToCreateRentalContract':
          'Liên hệ với chủ nhà để tạo hợp đồng thuê trọ',

      // Invoices
      'totalAmount': 'Tổng tiền',
      'dueDate': 'Hạn',
      'cannotNavigate': 'Không thể điều hướng',

      // Notifications
      'noNotificationsYet': 'Chưa có thông báo nào',

      // Maintenance
      'create': 'Tạo',
      'updated': 'Cập nhật',
      'created': 'Tạo',

      // Chat
      'noConversationsYet': 'Chưa có cuộc trò chuyện nào',
      'noMessagesYet': 'Chưa có tin nhắn nào',
      'startConversation': 'Hãy bắt đầu trò chuyện!',
      'cannotResendFile': 'Không thể gửi lại file. Vui lòng chọn file mới.',
      'addressUnknown': 'Địa chỉ không xác định',
      'selectImageFrom': 'Chọn hình ảnh từ',
      'landlord': 'Chủ nhà',

      // Contract Detail
      'contractDetail': 'Chi tiết hợp đồng',
      'contractInfo': 'Thông tin hợp đồng',
      'contractType': 'Loại hợp đồng',
      'startDate': 'Ngày bắt đầu',
      'endDate': 'Ngày kết thúc',
      'autoRenewal': 'Gia hạn tự động',
      'yes': 'Có',
      'no': 'Không',
      'noticePeriod': 'Thời gian báo hủy',
      'days': 'ngày',
      'notAvailable': 'Chưa có',

      // Report Detail
      'reportDetail': 'Chi tiết sự cố',
      'confirmCancel': 'Xác nhận huỷ',
      'confirmCancelReport': 'Bạn có chắc muốn huỷ báo cáo này?',
      'cancelReport': 'Huỷ báo cáo',
      'reportCancelled': 'Đã huỷ báo cáo',
      'confirmDelete': 'Xác nhận xoá',
      'confirmDeleteReport':
          'Bạn có chắc muốn xoá báo cáo này? Hành động này không thể hoàn tác.',
      'deleteReport': 'Xoá báo cáo',
      'reportDeleted': 'Đã xoá báo cáo',
      'reportNotFound': 'Không tìm thấy báo cáo',
      'status': 'Trạng thái',
      'locationInfo': 'Thông tin vị trí',
      'property': 'Bất động sản',
      'room': 'Phòng',
      'illustrationImage': 'Ảnh minh họa',
      'cannotLoadImage': 'Không thể tải ảnh',
      'timeInfo': 'Thông tin thời gian',
      'reportDate': 'Ngày báo cáo',
      'lastUpdated': 'Cập nhật lần cuối',

      // Contract Card
      'contractNumber': 'Hợp đồng #{id}',
      'rent': 'Tiền thuê',
      'perMonth': '/tháng',

      // Contract Detail Extended
      'viewContractFiles': 'Xem file hợp đồng ({count})',
      'noContractFiles': 'Chưa có file hợp đồng',
      'paymentInfo': 'Thông tin thanh toán',
      'monthlyRent': 'Tiền thuê hàng tháng',
      'deposit': 'Tiền cọc',
      'paymentCycle': 'Chu kỳ thanh toán',
      'paymentFrequency': 'Tần suất thanh toán',
      'timesPerCycle': 'lần/chu kỳ',
      'paymentDayType': 'Loại ngày thanh toán',
      'paymentDay': 'Ngày thanh toán',
      'day': 'Ngày',
      'signingStatus': 'Tình trạng ký kết',
      'landlordSigned': 'Chủ nhà đã ký',
      'tenantSigned': 'Người thuê đã ký',
      'signed': 'Đã ký',
      'notSigned': 'Chưa ký',
      'signingDate': 'Ngày ký',
      'terminationInfo': 'Thông tin chấm dứt',
      'reason': 'Lý do',
      'note': 'Ghi chú',
      'earlyTermination': 'Chấm dứt sớm',

      // Contract Files Viewer
      'downloading': 'Đang tải xuống...',
      'savedToDownload': 'Đã lưu vào thư mục Download',
      'savedToFiles': 'Đã lưu vào Files (On My iPhone → StayMate)',
      'open': 'Mở',
      'cannotOpenFile': 'Không thể mở file',
      'errorDownloadingFile': 'Lỗi khi tải file:',
      'openFile': 'Mở file',
      'close': 'Đóng',
      'download': 'Tải xuống',
      'cannotAccessStorage': 'Không thể truy cập thư mục lưu trữ',
      'platformNotSupported': 'Nền tảng không được hỗ trợ',

      // Invoice Detail
      'invoiceDetail': 'Chi tiết hoá đơn',
      'invoiceInfo': 'Chi tiết hoá đơn',
      'noInvoiceDetails': 'Chưa có chi tiết hoá đơn',
      'summary': 'Tổng kết',
      'total': 'Tổng tiền',
      'discount': 'Giảm giá',
      'lateFee': 'Phí trễ hạn',
      'totalAmountLabel': 'Tổng cộng',
      'tenant': 'Khách thuê',
      'paymentPeriod': 'Kỳ thanh toán',
      'payNow': 'Thanh toán ngay',
      'choosePaymentMethod': 'Chọn phương thức thanh toán',
      'invoiceNumber': 'Số hóa đơn',
      'amount': 'Số tiền',
      'qrPaymentUnderDevelopment':
          'Chức năng thanh toán QR đang được phát triển',
      'items': 'mục',

      // Bank Transfer
      'bankTransferInfo': 'Thông tin chuyển khoản',
      'amountToTransfer': 'Số tiền cần chuyển',
      'bank': 'Ngân hàng',
      'bankName': 'Tên ngân hàng',
      'accountNumber': 'Số tài khoản',
      'accountName': 'Tên tài khoản',
      'accountHolder': 'Tên tài khoản',
      'transferContent': 'Nội dung chuyển khoản',
      'branch': 'Chi nhánh',
      'noteLabel': 'Lưu ý',
      'transferNote':
          'Ghi đúng nội dung chuyển khoản. Khi đã chắc chắn chuyển khoản, hãy bấm nút xác nhận bên dưới.',
      'confirmPayment': 'Xác nhận thanh toán',
      'confirmPaymentMessage':
          'Bạn đã chuyển khoản theo đúng thông tin?\n\nHóa đơn sẽ chuyển sang trạng thái "Chờ duyệt" và chủ nhà sẽ xác nhận sau khi nhận được tiền.',
      'notYet': 'Chưa',
      'transferred': 'Đã chuyển khoản',
      'confirmTransferred': 'Xác nhận đã thanh toán',
      'copied': 'Đã sao chép {label}',
      'copiedToClipboard': 'Đã sao chép {label}',
      'accountInfoNotFound': 'Không tìm thấy thông tin tài khoản',
      'contactLandlordForSupport': 'Vui lòng liên hệ chủ nhà để được hỗ trợ',
      'errorLoadingInfo': 'Lỗi khi tải thông tin',
      'loadingAccountInfo': 'Đang tải thông tin tài khoản...',
      'cannotLoadAccountInfo': 'Không thể tải thông tin tài khoản',
      'receivingAccount': 'Tài khoản nhận tiền',
      'reviewTransferInfo': 'Xem lại thông tin chuyển khoản',
      'copy': 'Sao chép',
      'copyAmount': 'Sao chép số tiền',
      'copyBankName': 'Sao chép tên ngân hàng',
      'copyAccountNumber': 'Sao chép số tài khoản',
      'copyAccountName': 'Sao chép tên tài khoản',
      'copyTransferContent': 'Sao chép nội dung chuyển khoản',

      // Home
      'trackRoomRental': 'Theo dõi hợp đồng trọ',
      'scanQRCodeOrEnterCode':
          'Quét QR code hoặc nhập mã để kết nối với chủ nhà',
      'scanQRCode': 'Quét QR Code',
      'enterCode': 'Nhập mã',
      'homeGreetingMorning': 'Chào buổi sáng ☀️',
      'homeGreetingAfternoon': 'Chào buổi chiều 🌤️',
      'homeGreetingEvening': 'Chào buổi tối 🌙',
      'homeWelcomeMessage':
          'Dùng quét hoặc nhập mã hợp đồng để xem thông tin hợp đồng',
      'quickActions': 'Truy cập nhanh',
      'upcomingPayment': 'Thanh toán sắp tới',
      'dueSoon': 'Đến hạn trong 3 ngày',
      'noUpcomingPayments': 'Không có thanh toán sắp tới',
      'openReports': 'Báo cáo đang mở',
      'reportsPending': 'Đang chờ xử lý',
      'viewAll': 'Xem tất cả',
      'maintenanceRooms': 'Bảo trì (phòng)',
      'maintenanceInProgress': 'Đang bảo trì {{count}} đang được xử lý',
      'recentNotifications': 'Thông báo gần đây',
      'featureUnderDevelopment': 'Tính năng đang phát triển',

      // Chat Room Card
      'roomLabel': 'Phòng',

      // Message Input
      'enterMessage': 'Nhập tin nhắn...',
      'chooseAttachment': 'Chọn file đính kèm',
      'image': 'Hình ảnh',
      'selectImageFromLibrary': 'Chọn ảnh từ thư viện',
      'selectDocumentOrFile': 'Chọn tài liệu hoặc file khác',

      // Owner Detail
      'ownerInfo': 'Thông tin chủ nhà',
      'rentalPropertyInfo': 'Thông tin nhà cho thuê',
      'propertyName': 'Tên nhà',
      'address': 'Địa chỉ',

      // Profile Bottom Sheet
      'personalInfo': 'Thông tin cá nhân',
      'account': 'Tài khoản',
      'help': 'Trợ giúp',
      'loggedOutSuccessfully': 'Đã đăng xuất thành công!',
      'supportFromStayMate': 'Hỗ trợ từ ứng dụng Stay Mate',
      'cannotOpenEmailApp':
          'Không thể mở ứng dụng email. Vui lòng kiểm tra cài đặt của bạn.',
      'anErrorOccurredMessage': 'Đã xảy ra lỗi',
      'info': 'Thông tin',
      'changePassword': 'Đổi mật khẩu',
      'currentPassword': 'Mật khẩu hiện tại',
      'newPassword': 'Mật khẩu mới',
      'confirmNewPassword': 'Xác nhận mật khẩu mới',
      'passwordUpdated': 'Đã cập nhật mật khẩu',
      'passwordsDoNotMatch': 'Mật khẩu nhập lại không khớp',
      'passwordTooShort': 'Mật khẩu cần ít nhất 8 ký tự',
      'passwordChangeNotAvailableForSocialLogin':
          'Bạn đang đăng nhập bằng tài khoản mạng xã hội nên không thể đổi mật khẩu tại đây.',

      // App Info
      'appInfo': 'Thông tin ứng dụng',
      'version': 'Phiên bản',
      'checkForUpdate': 'Kiểm tra cập nhật',
      'appIsUpToDate': 'Ứng dụng đã được cập nhật',
      'youHaveLatestVersion': 'Bạn đang sử dụng phiên bản mới nhất',
      'additionalInfo': 'Thông tin bổ sung',
      'packageName': 'Tên gói',
      'buildNumber': 'Số bản dựng',
      'noUpdateAvailable': 'Không có bản cập nhật nào',
      'updateAvailable': 'Có bản cập nhật',
      'updateAvailableMessage':
          'Có phiên bản mới của ứng dụng. Bạn có muốn cập nhật ngay bây giờ?',
      'later': 'Để sau',
      'update': 'Cập nhật',
      'checkingForUpdate': 'Đang kiểm tra...',
      'newVersionAvailable': 'Có phiên bản mới, vui lòng cập nhật',
      'updateCheckNotAvailable': 'Không thể kiểm tra cập nhật',
      'updateCheckNotAvailableMessage':
          'Tính năng này chỉ hoạt động với app được cài từ Play Store',
      'updateCheckNotAvailableMessageIOS':
          'Tính năng này chỉ hoạt động với app được cài từ App Store',
      'privacyPolicy': 'Chính sách quyền riêng tư',
      'termsOfService': 'Điều khoản dịch vụ',
      'openPrivacyPolicy': 'Mở chính sách quyền riêng tư',
      'openTermsOfService': 'Mở điều khoản dịch vụ',
      'iAgreeTo': 'Tôi đồng ý với',
      'and': 'và',
      'mustAgreeToTerms':
          'Vui lòng đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư',

      // Onboarding
      'skip': 'Bỏ qua',
      'next': 'Tiếp theo',
      'back': 'Quay lại',
      'getStarted': 'Bắt đầu',
      'onboardingWelcomeTitle': 'Chào mừng đến với Stay Mate',
      'onboardingWelcomeDescription':
          'Ứng dụng quản lý thuê trọ tiện lợi, giúp bạn theo dõi hợp đồng, hóa đơn và giao tiếp với chủ nhà một cách dễ dàng.',
      'onboardingContractsTitle': 'Quản lý hợp đồng',
      'onboardingContractsDescription':
          'Xem chi tiết hợp đồng thuê, thông tin phòng, điều khoản và tải xuống tài liệu đính kèm.',
      'onboardingInvoicesTitle': 'Theo dõi hóa đơn',
      'onboardingInvoicesDescription':
          'Xem hóa đơn hàng tháng, thanh toán trực tuyến và theo dõi lịch sử thanh toán của bạn.',
      'onboardingReportsTitle': 'Báo cáo sự cố',
      'onboardingReportsDescription':
          'Báo cáo sự cố bảo trì kèm hình ảnh và theo dõi tiến độ xử lý từ chủ nhà.',
      'onboardingChatTitle': 'Nhắn tin với chủ nhà',
      'onboardingChatDescription':
          'Giao tiếp trực tiếp với chủ nhà, gửi tin nhắn, hình ảnh và tệp đính kèm một cách nhanh chóng.',
      'onboardingConnectTitle': 'Kết nối với chủ nhà',
      'onboardingConnectDescription':
          'Quét QR code hoặc nhập mã để liên kết tài khoản với chủ nhà và bắt đầu sử dụng các tính năng.',

      // Feedback
      'sendFeedback': 'Gửi phản hồi',
      'feedbackSubject': 'Tiêu đề',
      'feedbackSubjectHint': 'Nhập tiêu đề phản hồi của bạn',
      'feedbackMessage': 'Nội dung',
      'feedbackMessageHint':
          'Mô tả chi tiết phản hồi, đề xuất hoặc báo cáo lỗi...',
      'feedbackInfo':
          'Phản hồi của bạn sẽ được gửi qua email. Chúng tôi sẽ xem xét và phản hồi trong thời gian sớm nhất.',
      'feedbackSent': 'Cảm ơn bạn đã gửi phản hồi!',

      // Contract Status Values
      'contractStatusDraft': 'Nháp',
      'contractStatusActive': 'Đang hoạt động',
      'contractStatusExpired': 'Hết hạn',
      'contractStatusTerminated': 'Đã chấm dứt',

      // Contract Type Values
      'contractTypeRental': 'Hợp đồng thuê',
      'contractTypeUnknown': 'Không xác định',

      // Payment Cycle Values
      'paymentCycleMonthly': 'Hàng tháng',
      'paymentCycleQuarterly': 'Hàng quý',
      'paymentCycleYearly': 'Hàng năm',
      'paymentCycleUnknown': 'Không xác định',

      // Payment Day Type Values
      'paymentDayTypeFixedDays': 'Ngày cố định',
      'paymentDayTypeCustomDays': 'Ngày tùy chỉnh',
      'paymentDayTypeUnknown': 'Không xác định',

      // Termination Reason Values
      'terminationReasonExpired': 'Hết hạn',
      'terminationReasonViolation': 'Vi phạm',
      'terminationReasonTenantRequest': 'Yêu cầu của khách thuê',
      'terminationReasonLandlordRequest': 'Yêu cầu của chủ nhà',
      'terminationReasonOther': 'Khác',
    },
    'en': {
      // Auth
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'signInWithGoogle': 'Sign in with Google',
      'signUpWithGoogle': 'Sign up with Google',
      'signInWithApple': 'Sign in with Apple',
      'signUpWithApple': 'Sign up with Apple',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'fullName': 'Full Name',
      'logout': 'Logout',

      // Validation messages
      'pleaseEnterEmail': 'Please enter your email',
      'invalidEmail': 'Invalid email address',
      'pleaseEnterPassword': 'Please enter your password',
      'pleaseEnterName': 'Please enter your full name',
      'passwordMinLength': 'Password must be at least 6 characters',
      'pleaseCheckInternetConnection': 'Please check your internet connection',
      'pleaseFillAllFields': 'Please fill in all required fields',
      'authInvalidCredentials':
          'Incorrect email or password. Please try again.',
      'authEmailNotConfirmed':
          'Your email is not confirmed. Please check your inbox.',
      'authUserNotFound': 'Account not found. Please verify your email.',
      'authEmailAlreadyRegistered':
          'This email is already registered. Please sign in or use another email.',
      'authWeakPassword':
          'Password is too weak. Please use a stronger password.',
      'authInvalidEmail': 'Invalid email address. Please check again.',
      'authTooManyRequests':
          'Too many requests. Please try again in a few minutes.',
      'authInvalidPassword': 'Invalid password. Please try again.',
      'authOperationCancelled': 'The operation was cancelled.',
      'authGoogleSignInFailed': 'Google sign-in failed. Please try again.',
      'authGoogleSignInCancelled': 'Google sign-in was cancelled.',
      'authAppleSignInFailed': 'Apple sign-in failed. Please try again.',
      'authAppleSignInCancelled': 'Apple sign-in was cancelled.',
      'authAppleIdTokenError':
          'Unable to retrieve information from Apple. Please try again.',
      'authAppleAudienceError':
          'Apple Sign-In configuration error: Service ID mismatch. Please check Service ID in Supabase Dashboard (must be com.staymate.mobile.web, not com.staymate.mobile).',
      'authAdminBlocked':
          'This app is for tenants only. Admin features will be added later.',
      'authUnknownError': 'An unexpected error occurred. Please try again.',
      'authServerError': 'Server error. Please try again later.',
      'authTimeout': 'The request timed out. Please try again.',
      'authPermissionDenied':
          'You do not have permission to perform this action.',
      'authDataNotFound': 'Data not found. Please try again.',
      'authGoogleIdTokenError':
          'Unable to retrieve information from Google. Please try again.',
      'authSignUpEmailConfirmationRequired':
          'Registration successful! Please check your email and verify before signing in.',
      'signUpAccountTitle': 'Create an account',
      'signUpAccountSubtitle': 'Create a new account to use StayMate',
      'signUpSuccessShort': 'Signed up successfully!',
      'signUpErrorPrefix': 'Sign-up error',
      'orLabel': 'or',
      'alreadyHaveAccount': 'Already have an account? ',

      // Navigation
      'home': 'Home',
      'contracts': 'Contracts',
      'chat': 'Chat',
      'invoices': 'Invoices',
      'reports': 'Reports',
      'profile': 'Profile',
      'notifications': 'Notifications',
      'settings': 'Settings',
      'language': 'Language',
      'checkingNotificationStatus': 'Checking...',
      'notificationTypes': 'Notification Types',
      'notificationTypesDescription':
          'Receive notifications about important updates:',
      'notificationEnabled': 'Enabled',
      'notificationDisabled': 'Disabled',
      'notificationNotGranted': 'Not granted',
      'notificationTypeNewMessage': 'New Messages',
      'notificationTypeNewMessageDesc':
          'Get notified when you receive new messages',
      'notificationTypeContractUpdate': 'Contract Updates',
      'notificationTypeContractUpdateDesc':
          'Notifications about contract changes',
      'notificationTypeInvoice': 'Invoice Notifications',
      'notificationTypeInvoiceDesc':
          'Reminders about invoices that need payment',
      'notificationTypeNewReport': 'New Reports',
      'notificationTypeNewReportDesc': 'Updates about reports and issues',
      'openSystemSettings': 'Open System Settings',
      'manageInSettings': 'Manage in Settings',
      'notificationPermissionDeniedMessage':
          'To enable notifications, please open System Settings and enable notification permission for the app.',
      'notificationEnableMessage':
          'Turn on the switch above to receive notifications from the app.',
      'notificationEnabledSuccess': 'Notifications enabled successfully!',
      'notificationPermissionDenied': 'Notification permission denied',
      'errorCheckingStatus': 'Error checking status',
      'errorRequestingPermission': 'Error requesting permission',
      'cannotOpenSystemSettings': 'Cannot open system settings',
      'theme': 'Theme',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'themeSystem': 'System',
      'selectTheme': 'Select Theme',

      // Language
      'vietnamese': 'Vietnamese',
      'english': 'English',

      // Empty states
      'noContracts': 'No contracts',
      'noContractsFound': 'No contracts found',
      'noInvoices': 'No invoices',
      'noInvoicesFound': 'No invoices yet',
      'invoicesOfThisCategoryWillAppearHere':
          'Invoices for this tab will show up here once available.',
      'noReports': 'No reports',
      'noIssuesToReport': 'No issue reports yet',
      'yourReportedIssuesWillAppearHere':
          'Your reported issues will show up here once submitted.',
      'noChats': 'No chats',
      'chatStatusFailed': 'Failed to send',
      'chatStatusRetry': 'Resend',
      'chatStatusSending': 'Sending',
      'chatStatusDelivered': 'Delivered',
      'chatWillAppearWhenYouHaveContract':
          'Chat will appear when you have a contract connected with your landlord. This will create a conversation between you and your landlord.',
      'pleaseContactLandlord': 'Please contact your landlord',
      'startAConversationToSeeItHere': 'Start a conversation to see it here.',
      'noNotifications': 'No notifications yet',
      'noMaintenanceWork': 'No maintenance work yet',
      'noIssues': 'No issues',
      'pullDownToRefresh': 'Pull down to refresh',

      // Reports
      'createReport': 'Create Report',
      'reportIssue': 'Report Issue',
      'reportHeaderSubtitle': 'Please fill in all required information',
      'maintenanceWork': 'Maintenance Work',
      'issue': 'Issue',
      'issueDescription': 'Issue Description',
      'issueDescriptionHint': 'Describe the issue you need help with...',
      'issueImagesOptional': 'Illustration photos (optional)',
      'allGood': 'All good',
      'maintenanceWorkWillShowHere': 'Maintenance work will appear here',
      'fromYourReport': 'From your report',
      'viewOnlyCannotEdit': 'View only - You cannot edit maintenance work',
      'hasImage': 'Has image',
      'selectPropertyAndRoom': 'Please select a property and room',
      'selectPropertyPlaceholder': 'Select property',
      'selectPropertyFirst': 'Select a property first',
      'selectRoomPlaceholder': 'Select room',
      'pleaseSelectProperty': 'Please select a property',
      'pleaseSelectRoom': 'Please select a room',
      'pleaseEnterIssueDescription': 'Please enter an issue description',
      'descriptionMinCharacters': 'Description must have at least {count} characters',
      'unnamedRoom': 'Unnamed room',
      'maxImagesHint': 'Up to {count} photos',
      'imagePickerError': 'Image selection error: {error}',
      'addPhoto': 'Add photo',
      'add': 'Add',
      'reportSubmitSuccess': 'Report sent successfully, please wait for approval',
      'submitting': 'Submitting...',
      'submitReport': 'Submit report',

      // Status
      'pending': 'Pending',
      'approved': 'Approved',
      'rejected': 'Rejected',
      'cancelled': 'Cancelled',
      'paid': 'Paid',
      'unpaid': 'Unpaid',
      'processing': 'Processing',
      'overdue': 'Overdue',
      'partiallyPaid': 'Partially Paid',
      'all': 'All',
      'paidShort': 'Paid',
      'unpaidShort': 'Unpaid',
      'waitingApproval': 'Waiting Approval',
      'waitingProcess': 'Waiting Process',
      'inProgress': 'In Progress',
      'completed': 'Completed',

      // Common
      'error': 'Error',
      'tryAgain': 'Try Again',
      'anErrorOccurred': 'An error occurred',
      'loading': 'Loading...',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'view': 'View',
      'send': 'Send',
      'pay': 'Pay',
      'paymentMethodBankTransfer': 'Bank transfer',
      'paymentMethodQrCode': 'Scan QR code',
      'paymentMethodMomo': 'MoMo e-wallet',
      'paymentMethodZaloPay': 'ZaloPay',
      'paymentMethodCard': 'Credit/Debit card',
      'paymentMethodComingSoon': 'Coming soon',

      // Connectivity
      'online': 'Online',
      'offline': 'Offline',
      'noInternetConnection': 'No internet connection',
      'reconnected': 'Reconnected',
      'networkError': 'Network error',
      'networkErrorTryAgain': 'Network error. Please try again.',
      'networkErrorCheckConnection':
          'Network error. Please check your internet connection and try again.',

      // Media
      'camera': 'Camera',
      'gallery': 'Gallery',
      'file': 'File',

      // Time
      'justNow': 'Just now',
      'yesterday': 'Yesterday',
      'minutesAgo': '{minutes} minutes ago',
      'hoursAgo': '{hours} hours ago',
      'daysAgo': '{days} days ago',

      // User
      'user': 'User',
      'userId': 'User ID',
      'userIdLabel': 'ID: {userId}',
      'loginProvider': 'Login Provider',
      'loginProviderLabel': 'Login with {provider}',
      'deleteAccount': 'Delete account',
      'deleteAccountDescription':
          'This action will permanently delete your account and data. It cannot be undone.',
      'deleteAccountReasonPlaceholder': 'Reason (optional)',
      'deleteAccountReasonHint':
          'Share a short reason to help us improve (optional).',
      'deleteAccountAcknowledge':
          'I understand that my account and data will be permanently deleted.',
      'deleteAccountConfirm': 'Delete account',
      'deleteAccountSuccess': 'Your account has been deleted.',
      'deleteAccountFailed': 'Unable to delete your account. Please try again.',
      'deleteAccountInProgress': 'Deleting your account…',
      'deleteAccountDeletingData': 'Deleting data, please do not operate',
      'deleteAccountLongDescription':
          'Once you confirm, we will permanently erase your profile, rental data, chats, and notifications per Apple’s account-deletion policy.',
      'deleteAccountDataWipe':
          'All personal data and preferences will be removed immediately.',
      'deleteAccountIrreversible':
          'This action cannot be undone and you will lose access right away.',
      'deleteReasonPrivacy': 'Privacy concerns',
      'deleteReasonNoLongerRenting': 'I am no longer renting with StayMate',
      'deleteReasonBuggy': 'The app has issues/bugs',
      'deleteReasonOther': 'Other reasons',
      'secureLogin': 'Secure login',
      'memberSince': 'Member since {date}',

      // Auth Header
      'appDescription': 'Convenient room rental tracking application',
      'appDescriptionSubtitle': 'dedicated to tenants',

      // Success messages
      'signInSuccess': 'Sign in successful!',
      'signUpSuccess': 'Sign up successful! Welcome to StayMate!',
      'paymentRecorded':
          'Payment recorded. The landlord will confirm as soon as possible.',

      // Contracts
      'contractList': 'Contract List',
      'contractListCount': 'Contract List ({count})',
      'noContractsYet': 'No contracts yet',
      'contactLandlordToCreateContract':
          'Contact the landlord to create a contract',
      'contractStatus': 'Contract Status',
      'contractCount': 'Contract Count',
      'youHaveContracts': 'You have {count} rental contracts',
      'noContractYet': 'No contract yet',
      'contactLandlordToCreateRentalContract':
          'Contact the landlord to create a rental contract',

      // Invoices
      'totalAmount': 'Total Amount',
      'dueDate': 'Due',
      'cannotNavigate': 'Cannot navigate',

      // Notifications
      'noNotificationsYet': 'No notifications yet',

      // Maintenance
      'create': 'Created',
      'updated': 'Updated',
      'created': 'Created',

      // Chat
      'noConversationsYet': 'No conversations yet',
      'noMessagesYet': 'No messages yet',
      'startConversation': 'Start a conversation!',
      'cannotResendFile': 'Cannot resend file. Please select a new file.',
      'addressUnknown': 'Address unknown',
      'selectImageFrom': 'Select image from',
      'landlord': 'Landlord',

      // Contract Detail
      'contractDetail': 'Contract Detail',
      'contractInfo': 'Contract Information',
      'contractType': 'Contract Type',
      'startDate': 'Start Date',
      'endDate': 'End Date',
      'autoRenewal': 'Auto Renewal',
      'yes': 'Yes',
      'no': 'No',
      'noticePeriod': 'Notice Period',
      'days': 'days',
      'notAvailable': 'Not Available',

      // Report Detail
      'reportDetail': 'Report Detail',
      'confirmCancel': 'Confirm Cancel',
      'confirmCancelReport': 'Are you sure you want to cancel this report?',
      'cancelReport': 'Cancel Report',
      'reportCancelled': 'Report cancelled',
      'confirmDelete': 'Confirm Delete',
      'confirmDeleteReport':
          'Are you sure you want to delete this report? This action cannot be undone.',
      'deleteReport': 'Delete Report',
      'reportDeleted': 'Report deleted',
      'reportNotFound': 'Report not found',
      'status': 'Status',
      'locationInfo': 'Location Information',
      'property': 'Property',
      'room': 'Room',
      'illustrationImage': 'Illustration Image',
      'cannotLoadImage': 'Cannot load image',
      'timeInfo': 'Time Information',
      'reportDate': 'Report Date',
      'lastUpdated': 'Last Updated',

      // Contract Card
      'contractNumber': 'Contract #{id}',
      'rent': 'Rent',
      'perMonth': '/month',

      // Contract Detail Extended
      'viewContractFiles': 'View Contract Files ({count})',
      'noContractFiles': 'No contract files',
      'paymentInfo': 'Payment Information',
      'monthlyRent': 'Monthly Rent',
      'deposit': 'Deposit',
      'paymentCycle': 'Payment Cycle',
      'paymentFrequency': 'Payment Frequency',
      'timesPerCycle': 'times/cycle',
      'paymentDayType': 'Payment Day Type',
      'paymentDay': 'Payment Day',
      'day': 'Day',
      'signingStatus': 'Signing Status',
      'landlordSigned': 'Landlord Signed',
      'tenantSigned': 'Tenant Signed',
      'signed': 'Signed',
      'notSigned': 'Not Signed',
      'signingDate': 'Signing Date',
      'terminationInfo': 'Termination Information',
      'reason': 'Reason',
      'note': 'Note',
      'earlyTermination': 'Early Termination',

      // Contract Files Viewer
      'downloading': 'Downloading...',
      'savedToDownload': 'Saved to Download folder',
      'savedToFiles': 'Saved to Files (On My iPhone → StayMate)',
      'open': 'Open',
      'cannotOpenFile': 'Cannot open file',
      'errorDownloadingFile': 'Error downloading file:',
      'openFile': 'Open file',
      'close': 'Close',
      'download': 'Download',
      'cannotAccessStorage': 'Cannot access storage folder',
      'platformNotSupported': 'Platform not supported',

      // Invoice Detail
      'invoiceDetail': 'Invoice Detail',
      'invoiceInfo': 'Invoice Details',
      'noInvoiceDetails': 'No invoice details',
      'summary': 'Summary',
      'total': 'Total',
      'discount': 'Discount',
      'lateFee': 'Late Fee',
      'totalAmountLabel': 'Total Amount',
      'tenant': 'Tenant',
      'paymentPeriod': 'Payment Period',
      'payNow': 'Pay Now',
      'choosePaymentMethod': 'Choose Payment Method',
      'invoiceNumber': 'Invoice Number',
      'amount': 'Amount',
      'qrPaymentUnderDevelopment': 'QR payment feature is under development',
      'items': 'items',

      // Bank Transfer
      'bankTransferInfo': 'Bank Transfer Information',
      'amountToTransfer': 'Amount to Transfer',
      'bank': 'Bank',
      'bankName': 'Bank Name',
      'accountNumber': 'Account Number',
      'accountName': 'Account Name',
      'accountHolder': 'Account Holder',
      'transferContent': 'Transfer Content',
      'branch': 'Branch',
      'noteLabel': 'Note',
      'transferNote':
          'Please write the correct transfer content. When you are sure you have transferred, please click the confirm button below.',
      'confirmPayment': 'Confirm Payment',
      'confirmPaymentMessage':
          'Have you transferred according to the information?\n\nThe invoice will change to "Pending Approval" status and the landlord will confirm after receiving the money.',
      'notYet': 'Not Yet',
      'transferred': 'Transferred',
      'confirmTransferred': 'Confirm Payment',
      'copied': 'Copied {label}',
      'copiedToClipboard': 'Copied {label}',
      'accountInfoNotFound': 'Account information not found',
      'contactLandlordForSupport': 'Please contact the landlord for support',
      'errorLoadingInfo': 'Error loading information',
      'loadingAccountInfo': 'Loading account information...',
      'cannotLoadAccountInfo': 'Cannot load account information',
      'receivingAccount': 'Receiving Account',
      'reviewTransferInfo': 'Review Transfer Information',
      'copy': 'Copy',
      'copyAmount': 'Copy amount',
      'copyBankName': 'Copy bank name',
      'copyAccountNumber': 'Copy account number',
      'copyAccountName': 'Copy account name',
      'copyTransferContent': 'Copy transfer content',

      // Home
      'trackRoomRental': 'Track Room Rental',
      'scanQRCodeOrEnterCode':
          'Scan QR code or enter code to connect with landlord',
      'scanQRCode': 'Scan QR Code',
      'enterCode': 'Enter Code',
      'homeGreetingMorning': 'Good morning ☀️',
      'homeGreetingAfternoon': 'Good afternoon 🌤️',
      'homeGreetingEvening': 'Good evening 🌙',
      'homeWelcomeMessage': 'Use scan or enter contract code to view details',
      'quickActions': 'Quick Actions',
      'upcomingPayment': 'Upcoming payment',
      'dueSoon': 'Due within 3 days',
      'noUpcomingPayments': 'No upcoming payments',
      'openReports': 'Open reports',
      'reportsPending': 'Pending resolution',
      'viewAll': 'View all',
      'maintenanceRooms': 'Maintenance (rooms)',
      'maintenanceInProgress': '{{count}} maintenance tasks in progress',
      'recentNotifications': 'Recent Notifications',
      'featureUnderDevelopment': 'Feature under development',

      // Chat Room Card
      'roomLabel': 'Room',

      // Message Input
      'enterMessage': 'Enter message...',
      'chooseAttachment': 'Choose Attachment',
      'image': 'Image',
      'selectImageFromLibrary': 'Select image from library',
      'selectDocumentOrFile': 'Select document or other file',

      // Owner Detail
      'ownerInfo': 'Owner Information',
      'rentalPropertyInfo': 'Rental Property Information',
      'propertyName': 'Property Name',
      'address': 'Address',

      // Profile Bottom Sheet
      'personalInfo': 'Personal Information',
      'account': 'Account',
      'help': 'Help',
      'loggedOutSuccessfully': 'Logged out successfully!',
      'supportFromStayMate': 'Support from Stay Mate App',
      'cannotOpenEmailApp':
          'Cannot open email app. Please check your settings.',
      'anErrorOccurredMessage': 'An error occurred',
      'info': 'Info',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'confirmNewPassword': 'Confirm New Password',
      'passwordUpdated': 'Password updated successfully',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordTooShort': 'Password must be at least 8 characters',
      'passwordChangeNotAvailableForSocialLogin':
          'You are signed in with a social account, so password change is not available here.',

      // App Info
      'appInfo': 'App Information',
      'version': 'Version',
      'checkForUpdate': 'Check for Update',
      'appIsUpToDate': 'App is up to date',
      'youHaveLatestVersion': 'You have the latest version',
      'additionalInfo': 'Additional Information',
      'packageName': 'Package Name',
      'buildNumber': 'Build Number',
      'noUpdateAvailable': 'No update available',
      'updateAvailable': 'Update Available',
      'updateAvailableMessage':
          'A new version of the app is available. Would you like to update now?',
      'later': 'Later',
      'update': 'Update',
      'checkingForUpdate': 'Checking...',
      'newVersionAvailable': 'New version available, please update',
      'updateCheckNotAvailable': 'Update check not available',
      'updateCheckNotAvailableMessage':
          'This feature only works with apps installed from Play Store',
      'updateCheckNotAvailableMessageIOS':
          'This feature only works with apps installed from App Store',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'openPrivacyPolicy': 'Open Privacy Policy',
      'openTermsOfService': 'Open Terms of Service',
      'iAgreeTo': 'I agree to the',
      'and': 'and',
      'mustAgreeToTerms':
          'Please agree to the Terms of Service and Privacy Policy',

      // Onboarding
      'skip': 'Skip',
      'next': 'Next',
      'back': 'Back',
      'getStarted': 'Get Started',
      'onboardingWelcomeTitle': 'Welcome to Stay Mate',
      'onboardingWelcomeDescription':
          'A convenient rental management app that helps you track contracts, invoices, and communicate with your landlord easily.',
      'onboardingContractsTitle': 'Manage Contracts',
      'onboardingContractsDescription':
          'View rental contract details, room information, terms, and download attached documents.',
      'onboardingInvoicesTitle': 'Track Invoices',
      'onboardingInvoicesDescription':
          'View monthly invoices, make payments online, and track your payment history.',
      'onboardingReportsTitle': 'Report Issues',
      'onboardingReportsDescription':
          'Report maintenance issues with photos and track resolution progress from your landlord.',
      'onboardingChatTitle': 'Chat with Landlord',
      'onboardingChatDescription':
          'Communicate directly with your landlord, send messages, images, and attachments quickly.',
      'onboardingConnectTitle': 'Connect with Landlord',
      'onboardingConnectDescription':
          'Scan QR code or enter code to link your account with your landlord and start using features.',

      // Feedback
      'sendFeedback': 'Send Feedback',
      'feedbackSubject': 'Subject',
      'feedbackSubjectHint': 'Enter your feedback subject',
      'feedbackMessage': 'Message',
      'feedbackMessageHint':
          'Describe your feedback, suggestions, or bug reports in detail...',
      'feedbackInfo':
          'Your feedback will be sent via email. We will review and respond as soon as possible.',
      'feedbackSent': 'Thank you for your feedback!',

      // Contract Status Values
      'contractStatusDraft': 'Draft',
      'contractStatusActive': 'Active',
      'contractStatusExpired': 'Expired',
      'contractStatusTerminated': 'Terminated',

      // Contract Type Values
      'contractTypeRental': 'Rental Contract',
      'contractTypeUnknown': 'Unknown',

      // Payment Cycle Values
      'paymentCycleMonthly': 'Monthly',
      'paymentCycleQuarterly': 'Quarterly',
      'paymentCycleYearly': 'Yearly',
      'paymentCycleUnknown': 'Unknown',

      // Payment Day Type Values
      'paymentDayTypeFixedDays': 'Fixed Days',
      'paymentDayTypeCustomDays': 'Custom Days',
      'paymentDayTypeUnknown': 'Unknown',

      // Termination Reason Values
      'terminationReasonExpired': 'Expired',
      'terminationReasonViolation': 'Violation',
      'terminationReasonTenantRequest': 'Tenant Request',
      'terminationReasonLandlordRequest': 'Landlord Request',
      'terminationReasonOther': 'Other',
    },
  };

  /// Get translation by key
  static String translate(String key, String languageCode) {
    return _translations[languageCode]?[key] ??
        _translations['vi']?[key] ??
        key; // Fallback to key if not found
  }

  /// Get translation với placeholder
  static String translateWithParams(
    String key,
    String languageCode,
    Map<String, String> params,
  ) {
    String translation = translate(key, languageCode);

    // Replace placeholders
    params.forEach((paramKey, value) {
      translation = translation.replaceAll('{$paramKey}', value);
    });

    return translation;
  }
}

/// Extension để dễ dàng sử dụng translations trong widgets
extension LocalizationExtension on BuildContext {
  /// Get current language code from locale provider
  /// Note: This requires the widget to be within a ProviderScope
  String get languageCode {
    // Default to Vietnamese if cannot determine
    return 'vi';
  }

  /// Get translation by key
  String tr(String key) {
    return AppLocalizationsHelper.translate(key, languageCode);
  }

  /// Get translation with parameters
  String trWithParams(String key, Map<String, String> params) {
    return AppLocalizationsHelper.translateWithParams(
      key,
      languageCode,
      params,
    );
  }
}

/// Widget helper để sử dụng translations với Riverpod
class LocalizedText extends ConsumerWidget {
  final String translationKey;
  final Map<String, String>? params;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText(
    this.translationKey, {
    super.key,
    this.params,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    final text = params != null
        ? AppLocalizationsHelper.translateWithParams(
            translationKey,
            languageCode,
            params!,
          )
        : AppLocalizationsHelper.translate(translationKey, languageCode);

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
