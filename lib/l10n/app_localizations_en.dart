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
  String get noInvoices => 'No invoices';

  @override
  String get noReports => 'No reports';

  @override
  String get noChats => 'No chats';

  @override
  String get createReport => 'Create Report';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get maintenanceWork => 'Maintenance Work';

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
  String get startAConversationToSeeItHere =>
      'Start a conversation to see it here.';

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
}
