import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'StayMate'**
  String get appName;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign in with Google button text
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Sign up with Google button text
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// Sign in with Apple button text
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// Sign up with Apple button text
  ///
  /// In en, this message translates to:
  /// **'Sign up with Apple'**
  String get signUpWithApple;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Contracts tab label
  ///
  /// In en, this message translates to:
  /// **'Contracts'**
  String get contracts;

  /// Chat tab label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Invoices tab label
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// Reports tab label
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Notifications label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Vietnamese language option
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Empty state message for contracts
  ///
  /// In en, this message translates to:
  /// **'No contracts'**
  String get noContracts;

  /// Message displayed when no contracts match filters
  ///
  /// In en, this message translates to:
  /// **'No contracts found'**
  String get noContractsFound;

  /// Empty state message for invoices
  ///
  /// In en, this message translates to:
  /// **'No invoices'**
  String get noInvoices;

  /// Empty state message for reports
  ///
  /// In en, this message translates to:
  /// **'No reports'**
  String get noReports;

  /// Empty state message for chats
  ///
  /// In en, this message translates to:
  /// **'No chats'**
  String get noChats;

  /// No description provided for @chatStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send'**
  String get chatStatusFailed;

  /// No description provided for @chatStatusRetry.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get chatStatusRetry;

  /// No description provided for @chatStatusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get chatStatusSending;

  /// No description provided for @chatStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get chatStatusDelivered;

  /// Create report button text
  ///
  /// In en, this message translates to:
  /// **'Create Report'**
  String get createReport;

  /// Report issue label
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @reportHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required information'**
  String get reportHeaderSubtitle;

  /// No description provided for @issueDescription.
  ///
  /// In en, this message translates to:
  /// **'Issue Description'**
  String get issueDescription;

  /// No description provided for @issueDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue you need help with...'**
  String get issueDescriptionHint;

  /// No description provided for @issueImagesOptional.
  ///
  /// In en, this message translates to:
  /// **'Illustration photos (optional)'**
  String get issueImagesOptional;

  /// Maintenance work label
  ///
  /// In en, this message translates to:
  /// **'Maintenance Work'**
  String get maintenanceWork;

  /// No description provided for @selectPropertyAndRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select a property and room'**
  String get selectPropertyAndRoom;

  /// No description provided for @selectPropertyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select property'**
  String get selectPropertyPlaceholder;

  /// No description provided for @selectPropertyFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a property first'**
  String get selectPropertyFirst;

  /// No description provided for @selectRoomPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select room'**
  String get selectRoomPlaceholder;

  /// No description provided for @pleaseSelectProperty.
  ///
  /// In en, this message translates to:
  /// **'Please select a property'**
  String get pleaseSelectProperty;

  /// No description provided for @pleaseSelectRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select a room'**
  String get pleaseSelectRoom;

  /// No description provided for @pleaseEnterIssueDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter an issue description'**
  String get pleaseEnterIssueDescription;

  /// No description provided for @descriptionMinCharacters.
  ///
  /// In en, this message translates to:
  /// **'Description must have at least {count} characters'**
  String descriptionMinCharacters(Object count);

  /// No description provided for @unnamedRoom.
  ///
  /// In en, this message translates to:
  /// **'Unnamed room'**
  String get unnamedRoom;

  /// No description provided for @maxImagesHint.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} photos'**
  String maxImagesHint(Object count);

  /// No description provided for @imagePickerError.
  ///
  /// In en, this message translates to:
  /// **'Image selection error: {error}'**
  String imagePickerError(Object error);

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @reportSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report sent successfully, please wait for approval'**
  String get reportSubmitSuccess;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get submitReport;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Approved status
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Rejected status
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// View button text
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Pay button text
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get paymentMethodQrCode;

  /// No description provided for @paymentMethodMomo.
  ///
  /// In en, this message translates to:
  /// **'MoMo e-wallet'**
  String get paymentMethodMomo;

  /// No description provided for @paymentMethodZaloPay.
  ///
  /// In en, this message translates to:
  /// **'ZaloPay'**
  String get paymentMethodZaloPay;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get paymentMethodComingSoon;

  /// Paid status
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Unpaid status
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// Online status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No internet connection message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Reconnected message
  ///
  /// In en, this message translates to:
  /// **'Reconnected'**
  String get reconnected;

  /// Camera label
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery label
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// File label
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// Just now time label
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Minutes ago time label
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// Hours ago time label
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Days ago time label
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Tooltip for features that are not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get featureComingSoon;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Hint text for pull-to-refresh functionality
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullDownToRefresh;

  /// Subtitle for empty chat list
  ///
  /// In en, this message translates to:
  /// **'Start a conversation to see it here.'**
  String get startAConversationToSeeItHere;

  /// Title for empty chat list
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// Message explaining that chat appears when user has a contract with landlord
  ///
  /// In en, this message translates to:
  /// **'Chat will appear when you have a contract connected with your landlord. This will create a conversation between you and your landlord.'**
  String get chatWillAppearWhenYouHaveContract;

  /// Instruction to contact landlord
  ///
  /// In en, this message translates to:
  /// **'Please contact your landlord'**
  String get pleaseContactLandlord;

  /// Title for empty invoice list
  ///
  /// In en, this message translates to:
  /// **'No Invoices Found'**
  String get noInvoicesFound;

  /// Subtitle for empty invoice list
  ///
  /// In en, this message translates to:
  /// **'Invoices in this category will appear here.'**
  String get invoicesOfThisCategoryWillAppearHere;

  /// Title for empty maintenance request list
  ///
  /// In en, this message translates to:
  /// **'No Issues to Report'**
  String get noIssuesToReport;

  /// Subtitle for empty maintenance request list
  ///
  /// In en, this message translates to:
  /// **'Your reported issues will appear here.'**
  String get yourReportedIssuesWillAppearHere;

  /// Message shown when the app is trying to reconnect
  ///
  /// In en, this message translates to:
  /// **'Connection issue. Reconnecting...'**
  String get reconnecting;

  /// Personal information label
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// Account label
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// User label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Full name label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// User ID label
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// Created date label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Login provider label
  ///
  /// In en, this message translates to:
  /// **'Login Provider'**
  String get loginProvider;

  /// Member since label
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(String date);

  /// User ID label with value
  ///
  /// In en, this message translates to:
  /// **'ID: {userId}'**
  String userIdLabel(String userId);

  /// Login provider label with value
  ///
  /// In en, this message translates to:
  /// **'Login with {provider}'**
  String loginProviderLabel(String provider);

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete your account and data. It cannot be undone.'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountReasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get deleteAccountReasonPlaceholder;

  /// No description provided for @deleteAccountReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Share a short reason to help us improve (optional)'**
  String get deleteAccountReasonHint;

  /// No description provided for @deleteAccountAcknowledge.
  ///
  /// In en, this message translates to:
  /// **'I understand that my account and data will be permanently deleted.'**
  String get deleteAccountAcknowledge;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete your account. Please try again.'**
  String get deleteAccountFailed;

  /// No description provided for @deleteAccountInProgress.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account…'**
  String get deleteAccountInProgress;

  /// No description provided for @deleteAccountDeletingData.
  ///
  /// In en, this message translates to:
  /// **'Deleting data, please do not operate'**
  String get deleteAccountDeletingData;

  /// No description provided for @deleteAccountLongDescription.
  ///
  /// In en, this message translates to:
  /// **'Once you confirm, we will permanently erase your profile, rental data, chat history, and notifications. This follows Apple\'s account-deletion policy.'**
  String get deleteAccountLongDescription;

  /// No description provided for @deleteAccountDataWipe.
  ///
  /// In en, this message translates to:
  /// **'All personal data and preferences will be removed immediately.'**
  String get deleteAccountDataWipe;

  /// No description provided for @deleteAccountIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone and you will lose access right away.'**
  String get deleteAccountIrreversible;

  /// No description provided for @deleteReasonPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy concerns'**
  String get deleteReasonPrivacy;

  /// No description provided for @deleteReasonNoLongerRenting.
  ///
  /// In en, this message translates to:
  /// **'I am no longer renting with StayMate'**
  String get deleteReasonNoLongerRenting;

  /// No description provided for @deleteReasonBuggy.
  ///
  /// In en, this message translates to:
  /// **'The app has issues/bugs'**
  String get deleteReasonBuggy;

  /// No description provided for @deleteReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other reasons'**
  String get deleteReasonOther;

  /// Secure login label
  ///
  /// In en, this message translates to:
  /// **'Secure Login'**
  String get secureLogin;

  /// Change password label
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Current password label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// New password label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm new password label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Password updated message
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// Passwords do not match error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Password too short error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// Message shown when password change is not available for social login
  ///
  /// In en, this message translates to:
  /// **'You are signed in with a social account (Google/Apple). To change your password, please use an email account.'**
  String get passwordChangeNotAvailableForSocialLogin;

  /// Logged out success message
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// Select theme title
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Theme label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Send feedback label
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// App information label
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// No description provided for @anErrorOccurredMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurredMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
