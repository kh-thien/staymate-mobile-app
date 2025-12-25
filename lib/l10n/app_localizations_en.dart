// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StayMate';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signUpWithApple => 'Sign up with Apple';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get home => 'Home';

  @override
  String get contracts => 'Contracts';

  @override
  String get chat => 'Chat';

  @override
  String get invoices => 'Invoices';

  @override
  String get reports => 'Reports';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get logout => 'Logout';

  @override
  String get noContracts => 'No contracts';

  @override
  String get noContractsFound => 'No contracts found';

  @override
  String get noInvoices => 'No invoices';

  @override
  String get noReports => 'No reports';

  @override
  String get noChats => 'No chats';

  @override
  String get chatStatusFailed => 'Failed to send';

  @override
  String get chatStatusRetry => 'Resend';

  @override
  String get chatStatusSending => 'Sending';

  @override
  String get chatStatusDelivered => 'Delivered';

  @override
  String get createReport => 'Create Report';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get reportHeaderSubtitle => 'Please fill in all required information';

  @override
  String get issueDescription => 'Issue Description';

  @override
  String get issueDescriptionHint => 'Describe the issue you need help with...';

  @override
  String get issueImagesOptional => 'Illustration photos (optional)';

  @override
  String get maintenanceWork => 'Maintenance Work';

  @override
  String get selectPropertyAndRoom => 'Please select a property and room';

  @override
  String get selectPropertyPlaceholder => 'Select property';

  @override
  String get selectPropertyFirst => 'Select a property first';

  @override
  String get selectRoomPlaceholder => 'Select room';

  @override
  String get pleaseSelectProperty => 'Please select a property';

  @override
  String get pleaseSelectRoom => 'Please select a room';

  @override
  String get pleaseEnterIssueDescription => 'Please enter an issue description';

  @override
  String descriptionMinCharacters(Object count) {
    return 'Description must have at least $count characters';
  }

  @override
  String get unnamedRoom => 'Unnamed room';

  @override
  String maxImagesHint(Object count) {
    return 'Up to $count photos';
  }

  @override
  String imagePickerError(Object error) {
    return 'Image selection error: $error';
  }

  @override
  String get addPhoto => 'Add photo';

  @override
  String get add => 'Add';

  @override
  String get reportSubmitSuccess =>
      'Report sent successfully, please wait for approval';

  @override
  String get submitting => 'Submitting...';

  @override
  String get submitReport => 'Submit report';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get anErrorOccurred => 'An error occurred';

  @override
  String get loading => 'Loading...';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get view => 'View';

  @override
  String get send => 'Send';

  @override
  String get pay => 'Pay';

  @override
  String get paymentMethodBankTransfer => 'Bank transfer';

  @override
  String get paymentMethodQrCode => 'Scan QR code';

  @override
  String get paymentMethodMomo => 'MoMo e-wallet';

  @override
  String get paymentMethodZaloPay => 'ZaloPay';

  @override
  String get paymentMethodCard => 'Credit/Debit card';

  @override
  String get paymentMethodComingSoon => 'Coming soon';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get reconnected => 'Reconnected';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get file => 'File';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get featureComingSoon => 'Feature coming soon';

  @override
  String get refresh => 'Refresh';

  @override
  String get pullDownToRefresh => 'Pull down to refresh';

  @override
  String get startAConversationToSeeItHere =>
      'Start a conversation to see it here.';

  @override
  String get noConversationsYet => 'No conversations yet';

  @override
  String get chatWillAppearWhenYouHaveContract =>
      'Chat will appear when you have a contract connected with your landlord. This will create a conversation between you and your landlord.';

  @override
  String get pleaseContactLandlord => 'Please contact your landlord';

  @override
  String get noInvoicesFound => 'No Invoices Found';

  @override
  String get invoicesOfThisCategoryWillAppearHere =>
      'Invoices in this category will appear here.';

  @override
  String get noIssuesToReport => 'No Issues to Report';

  @override
  String get yourReportedIssuesWillAppearHere =>
      'Your reported issues will appear here.';

  @override
  String get reconnecting => 'Connection issue. Reconnecting...';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get account => 'Account';

  @override
  String get user => 'User';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get userId => 'User ID';

  @override
  String get created => 'Created';

  @override
  String get loginProvider => 'Login Provider';

  @override
  String memberSince(String date) {
    return 'Member since $date';
  }

  @override
  String userIdLabel(String userId) {
    return 'ID: $userId';
  }

  @override
  String loginProviderLabel(String provider) {
    return 'Login with $provider';
  }

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountDescription =>
      'This action will permanently delete your account and data. It cannot be undone.';

  @override
  String get deleteAccountReasonPlaceholder => 'Reason (optional)';

  @override
  String get deleteAccountReasonHint =>
      'Share a short reason to help us improve (optional)';

  @override
  String get deleteAccountAcknowledge =>
      'I understand that my account and data will be permanently deleted.';

  @override
  String get deleteAccountConfirm => 'Delete account';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted.';

  @override
  String get deleteAccountFailed =>
      'Unable to delete your account. Please try again.';

  @override
  String get deleteAccountInProgress => 'Deleting your account…';

  @override
  String get deleteAccountDeletingData =>
      'Deleting data, please do not operate';

  @override
  String get deleteAccountLongDescription =>
      'Once you confirm, we will permanently erase your profile, rental data, chat history, and notifications. This follows Apple\'s account-deletion policy.';

  @override
  String get deleteAccountDataWipe =>
      'All personal data and preferences will be removed immediately.';

  @override
  String get deleteAccountIrreversible =>
      'This action cannot be undone and you will lose access right away.';

  @override
  String get deleteReasonPrivacy => 'Privacy concerns';

  @override
  String get deleteReasonNoLongerRenting =>
      'I am no longer renting with StayMate';

  @override
  String get deleteReasonBuggy => 'The app has issues/bugs';

  @override
  String get deleteReasonOther => 'Other reasons';

  @override
  String get secureLogin => 'Secure Login';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordUpdated => 'Password updated successfully';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordChangeNotAvailableForSocialLogin =>
      'You are signed in with a social account (Google/Apple). To change your password, please use an email account.';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get theme => 'Theme';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get appInfo => 'App Information';

  @override
  String get anErrorOccurredMessage => 'An error occurred';
}
