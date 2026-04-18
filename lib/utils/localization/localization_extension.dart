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
}
