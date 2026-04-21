import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension LocalizationExtension on BuildContext {
    String get bespokeAtelier => _l10n?.bespokeAtelier ?? 'THE BESPOKE ATELIER';
  AppLocalizations? get _l10n => AppLocalizations.of(this);

  // Quick access to translations
  String get sangamnerAi => _l10n?.sangamnerAi ?? 'Sangamner AI';
  String get homeTitle =>
      _l10n?.homeTitle ?? 'Discover Sangamner\nOne Place at a Time';
  String get homeSubtitle =>
      _l10n?.homeSubtitle ??
      'Find nearby shops, services, food,\nand everything you need all in one app.';
  String get welcomeToBaapCompany =>
      _l10n?.welcomeToBaapCompany ?? 'Welcome to Baap Company';
  String get changeLanguage => _l10n?.changeLanguage ?? 'Change Language';
  String get marathi => _l10n?.marathi ?? 'Marathi';
  String get dashboard => _l10n?.dashboard ?? 'Dashboard';
  String get login => _l10n?.login ?? 'Login';
  String get emailOrMobile => _l10n?.emailOrMobile ?? 'Email or Mobile';
  String get enterEmailOrMobile => _l10n?.enterEmailOrMobile ?? 'Enter Email or Mobile';
  String get password => _l10n?.password ?? 'Password';
  String get enterPassword => _l10n?.enterPassword ?? 'Enter Password';
  String get forgotPassword => _l10n?.forgotPassword ?? 'Forgot Password?';
  String get dontHaveAccount => _l10n?.dontHaveAccount ?? 'Don\'t have an account?';
  String get signUp => _l10n?.signUp ?? 'Sign Up';
  String get loggingIn => _l10n?.loggingIn ?? 'Logging in...';
  String get bySigningIn => _l10n?.bySigningIn ?? 'By signing in, you agree to our';
  String get termsOfServices => _l10n?.termsOfServices ?? 'Terms of Service';
  String get and => _l10n?.and ?? 'and';
  String get privacyPolicy => _l10n?.privacyPolicy ?? 'Privacy Policy';
  String get pleaseLoginEmailPassword => _l10n?.pleaseLoginEmailPassword ?? 'Please login with email and password';

  String get welcomeBack => _l10n?.welcomeBack ?? 'Welcome Back';
  String get enterCredentials => _l10n?.enterCredentials ?? 'Enter your credentials to access the studio dashboard.';
  String get mobileNumber => _l10n?.mobileNumber ?? 'MOBILE NUMBER';
  String get useOtpInstead => _l10n?.useOtpInstead ?? 'Use OTP Instead?';
  String get rememberDevice => _l10n?.rememberDevice ?? 'Remember device';
  String get enterAtelier => _l10n?.enterAtelier ?? 'Enter Atelier';
  String get sendOtp => _l10n?.sendOtp ?? 'Send OTP';
  String get newToSuite => _l10n?.newToSuite ?? 'New to the management suite?  ';
  String get joinAsPartner => _l10n?.joinAsPartner ?? 'Join as a Partner';

  // ── Home Screen ──
  String get hello => _l10n?.hello ?? 'Hello';
  String get activeOrdersSubtitle => _l10n?.activeOrdersSubtitle ?? 'Your workshop is handling {count} active orders';
  String get aiInsights => _l10n?.aiInsights ?? 'AI Insights';
  String get aiInsightsDelayed => _l10n?.aiInsightsDelayed ?? 'All insights. You have {count} delayed orders today.';
  String get aiInsightsSuggestion => _l10n?.aiInsightsSuggestion ?? 'Prioritise these for customer satisfaction, suggesting to reduce up-coming fabric orders.';
  String get viewDelayedOrders => _l10n?.viewDelayedOrders ?? 'View Delayed Orders';
  String get dismissText => _l10n?.dismissText ?? 'Dismiss';
  String get createOrder => _l10n?.createOrder ?? 'Create Order';
  String get customerLabel => _l10n?.customerLabel ?? 'Customer';
  String get totalOrders => _l10n?.totalOrders ?? 'Total Orders';
  String get pendingLabel => _l10n?.pendingLabel ?? 'Pending';
  String get deliveredLabel => _l10n?.deliveredLabel ?? 'Delivered';
  String get collectedLabel => _l10n?.collectedLabel ?? 'Collected';
  String get thisMonth => _l10n?.thisMonth ?? 'This month';
  String get recentBoutiqueActivity => _l10n?.recentBoutiqueActivity ?? 'Recent Boutique Activity';
  String get seeAll => _l10n?.seeAll ?? 'See all';
  String get noRecentActivity => _l10n?.noRecentActivity ?? 'No recent activity';
  String get financialOverview => _l10n?.financialOverview ?? 'Financial Overview';
  String get monthlyTarget => _l10n?.monthlyTarget ?? 'of ₹{amount} monthly target';
  String get achievedLabel => _l10n?.achievedLabel ?? '{percent}% achieved';
  String get remainingLabel => _l10n?.remainingLabel ?? '{percent}% remaining';
  String get inProgressLabel => _l10n?.inProgressLabel ?? 'In Progress';

  // ── Add Customer Screen ──
  String get addCustomer => _l10n?.addCustomer ?? 'Add Customer';
  String get save => _l10n?.save ?? 'Save';
  String get contactDetails => _l10n?.contactDetails ?? 'Contact Details';
  String get fullName => _l10n?.fullName ?? 'Full Name';
  String get fullNameHint => _l10n?.fullNameHint ?? 'e.g. Sebastian Vael';
  String get pleaseEnterFullName => _l10n?.pleaseEnterFullName ?? 'Please enter full name';
  String get phoneNumberLabel => _l10n?.phoneNumberLabel ?? 'Phone Number';
  String get enter10DigitNumber => _l10n?.enter10DigitNumber ?? 'Enter 10-digit number';
  String get emailAddressLabel => _l10n?.emailAddressLabel ?? 'Email Address';
  String get emailHint => _l10n?.emailHint ?? 'customer@domain.com';
  String get saveCustomer => _l10n?.saveCustomer ?? 'Save Customer';
  String get customerAddedSuccessfully => _l10n?.customerAddedSuccessfully ?? 'Customer added successfully!';
  String get errorPrefix => _l10n?.errorPrefix ?? 'Error';

  // ── Confirm Customer Bottom Sheet ──
  String get reviewClientProfile => _l10n?.reviewClientProfile ?? 'Review Client Profile';
  String get confirmNewCustomer => _l10n?.confirmNewCustomer ?? 'Confirm New Customer';
  String get verifyProfileDetails => _l10n?.verifyProfileDetails ?? 'Please verify the bespoke profile details\nbefore finalization.';
  String get contact => _l10n?.contact ?? 'Contact';
  String get fullNameLabel => _l10n?.fullNameLabel ?? 'FULL NAME';
  String get phoneLabel => _l10n?.phoneLabel ?? 'PHONE';
  String get emailLabel => _l10n?.emailLabel ?? 'EMAIL';
  String get preferences => _l10n?.preferences ?? 'Preferences';
  String get priorityLabel => _l10n?.priorityLabel ?? 'PRIORITY';
  String get urgentLabel => _l10n?.urgentLabel ?? 'Urgent';
  String get standardLabel => _l10n?.standardLabel ?? 'Standard';
  String get fitStyle => _l10n?.fitStyle ?? 'FIT STYLE';
  String get fabricClass => _l10n?.fabricClass ?? 'FABRIC CLASS';
  String get super150sWool => _l10n?.super150sWool ?? 'Super 150s Wool';
  String get internalNotes => _l10n?.internalNotes ?? 'INTERNAL NOTES';
  String get editDetails => _l10n?.editDetails ?? 'Edit Details';
  String get cancelButton => _l10n?.cancelButton ?? 'Cancel';
  String get confirmProfile => _l10n?.confirmProfile ?? 'Confirm Profile';

  // ── Customers Screen ──
  String get customersTitle => _l10n?.customersTitle ?? 'Customers';
  String get manageBespokeClients => _l10n?.manageBespokeClients ?? 'Manage your {count} bespoke clients';
  String get searchClientsHint => _l10n?.searchClientsHint ?? 'Search clients by name or phone...';
  String get noMoreCustomers => _l10n?.noMoreCustomers ?? 'No more customers';
  String get billPrefix => _l10n?.billPrefix ?? 'BILL';
  String get statusLabel => _l10n?.statusLabel ?? 'STATUS';
  String get noEmailProvided => _l10n?.noEmailProvided ?? 'No email provided';
  String get viewProfile => _l10n?.viewProfile ?? 'View Profile';
  String get billNoLabel => _l10n?.billNoLabel ?? 'Bill No';
  String get generateAiStyleProfile => _l10n?.generateAiStyleProfile ?? 'Generate AI Style Profile';

  // ── Staff Management Screen ──
  String get staffManagement => _l10n?.staffManagement ?? 'Staff Management';
  String get staffManagementDesc => _l10n?.staffManagementDesc ?? 'Organize and monitor your atelier\'s expert artisans.';
  String get addStaff => _l10n?.addStaff ?? 'Add Staff';
  String get activeUpper => _l10n?.activeUpper ?? 'ACTIVE';
  String get totalArtisans => _l10n?.totalArtisans ?? 'Total Artisans';
  String get currentWorkload => _l10n?.currentWorkload ?? 'Current Workload';
  String get ordersText => _l10n?.ordersText ?? 'Orders';
  String get efficiencyRate => _l10n?.efficiencyRate ?? 'Efficiency Rate';
  String get staffArtisanUpper => _l10n?.staffArtisanUpper ?? 'STAFF ARTISAN';
  String get assignedOrders => _l10n?.assignedOrders ?? 'Assigned Orders';
  String get overCapacity => _l10n?.overCapacity ?? 'OVER CAPACITY';
  String get capacityLabel => _l10n?.capacityLabel ?? 'Capacity:';
  String get onboardNewArtisan => _l10n?.onboardNewArtisan ?? 'Onboard New Artisan';
  String get retry => _l10n?.retry ?? 'Retry';
  // ── Gallery Screen ──
  String get galleryCuratedPortfolio => _l10n?.galleryCuratedPortfolio ?? 'CURATED PORTFOLIO';
  String get galleryArchiveOfExcellence => _l10n?.galleryArchiveOfExcellence ?? 'Archive of\nExcellence';
  String get galleryAddPortfolioItem => _l10n?.galleryAddPortfolioItem ?? 'Add Portfolio Item';
  String get galleryTapToUploadPhoto => _l10n?.galleryTapToUploadPhoto ?? 'Tap to Upload Photo';
  String get galleryItemTitle => _l10n?.galleryItemTitle ?? 'Item Title';
  String get galleryEgTitle => _l10n?.galleryEgTitle ?? 'e.g. Midnight Blue Three-Piece';
  String get galleryMaterialSubtitle => _l10n?.galleryMaterialSubtitle ?? 'Material / Subtitle';
  String get galleryEgSubtitle => _l10n?.galleryEgSubtitle ?? 'e.g. Super 150s Merino Wool';
  String get galleryAddToArchive => _l10n?.galleryAddToArchive ?? 'ADD TO ARCHIVE';
  String get galleryFilterAllWorks => _l10n?.galleryFilterAllWorks ?? 'All Works';
  String get galleryFilterSuits => _l10n?.galleryFilterSuits ?? 'Suits';
  String get galleryFilterCasual => _l10n?.galleryFilterCasual ?? 'Casual';
  String get galleryFilterFabrics => _l10n?.galleryFilterFabrics ?? 'Fabrics';
  String get galleryFilterFittings => _l10n?.galleryFilterFittings ?? 'Fittings';
}
