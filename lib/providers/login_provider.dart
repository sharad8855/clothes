import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

/// Authentication mode: Password or OTP
enum AuthMode { password, otp }

/// Detected credential type based on user input
enum CredentialType { mobile, email }

/// State for the Login Screen
class LoginProvider extends ChangeNotifier {
  // ─── Auth mode (Password vs OTP) ─────────────────────────────
  AuthMode _authMode = AuthMode.password;
  AuthMode get authMode => _authMode;

  void toggleAuthMode() {
    _authMode =
        _authMode == AuthMode.password ? AuthMode.otp : AuthMode.password;
    _password = '';
    _passwordError = null;
    _apiError = null;
    notifyListeners();
  }

  // ─── Credential (auto-detect mobile / email) ─────────────────
  String _credential = '';
  String get credential => _credential;

  String? _credentialError;
  String? get credentialError => _credentialError;

  /// Returns the detected type based on what the user has typed so far.
  /// If the input contains '@' it is treated as email, else mobile.
  CredentialType get credentialType =>
      _credential.contains('@') ? CredentialType.email : CredentialType.mobile;

  void setCredential(String value) {
    _credential = value;
    _credentialError = null;
    _apiError = null;

    // Live mobile-length guard (only when looks like a phone)
    if (credentialType == CredentialType.mobile) {
      final digitsOnly = _credential.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length > 10) {
        _credentialError = 'Mobile number cannot exceed 10 digits';
      }
    }

    notifyListeners();
  }

  // ─── Password ────────────────────────────────────────────────
  String _password = '';
  String get password => _password;

  String? _passwordError;
  String? get passwordError => _passwordError;

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  void setPassword(String value) {
    _password = value;
    _passwordError = null;
    _apiError = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // ─── Remember device ─────────────────────────────────────────
  bool _rememberDevice = false;
  bool get rememberDevice => _rememberDevice;

  void toggleRememberDevice() {
    _rememberDevice = !_rememberDevice;
    notifyListeners();
  }

  // ─── API / network error message ─────────────────────────────
  String? _apiError;
  String? get apiError => _apiError;

  // ─── Logged-in user (set after successful login) ─────────────
  UserModel? _loggedInUser;
  UserModel? get loggedInUser => _loggedInUser;

  // ─── Loading state ───────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Validation ──────────────────────────────────────────────
  bool _validate() {
    bool valid = true;

    if (_credential.trim().isEmpty) {
      _credentialError = 'Please enter your mobile number or email';
      valid = false;
    } else if (credentialType == CredentialType.mobile) {
      final digitsOnly = _credential.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 10) {
        _credentialError = 'Enter a valid 10-digit mobile number';
        valid = false;
      } else if (digitsOnly.length > 10) {
        _credentialError = 'Mobile number cannot exceed 10 digits';
        valid = false;
      }
    } else {
      // Email validation
      if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+').hasMatch(_credential.trim())) {
        _credentialError = 'Enter a valid email address';
        valid = false;
      }
    }

    if (_authMode == AuthMode.password) {
      if (_password.isEmpty) {
        _passwordError = 'Please enter your password';
        valid = false;
      } else if (_password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        valid = false;
      }
    }

    notifyListeners();
    return valid;
  }

  // ─── Submit ──────────────────────────────────────────────────
  /// Returns true on success, false on failure.
  Future<bool> submit() async {
    if (!_validate()) return false;

    _isLoading = true;
    _apiError = null;
    notifyListeners();

    try {
      final isEmail = credentialType == CredentialType.email;
      final authResponse = await AuthService.loginWithPassword(
        phone: isEmail ? null : _credential.trim(),
        email: isEmail ? _credential.trim() : null,
        password: _password,
      );

      // Save initial session to provide token for the profile fetch
      await SessionManager.instance.saveSession(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        user: authResponse.user,
      );

      // Immediately fetch the full profile to get roles and permissions
      final detailedUser =
          await AuthService.getUserProfile(authResponse.user.id);

      // Update session with the detailed user profile
      await SessionManager.instance.saveSession(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        user: detailedUser,
      );

      _loggedInUser = detailedUser;

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _apiError = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _apiError = 'Unexpected error. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ─── Logout ──────────────────────────────────────────────────
  Future<void> logout() async {
    await SessionManager.instance.clearSession();
    _loggedInUser = null;
    _credential = '';
    _password = '';
    _apiError = null;
    notifyListeners();
  }
}
