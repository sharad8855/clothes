import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

/// Authentication mode: Password or OTP
enum AuthMode { password, otp }

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

  // ─── Credential (mobile / email) ─────────────────────────────
  String _credential = '';
  String get credential => _credential;

  String? _credentialError;
  String? get credentialError => _credentialError;

  void setCredential(String value) {
    _credential = value;
    _credentialError = null;
    _apiError = null;
    
    final digitsOnly = _credential.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 10) {
      _credentialError = 'Mobile number cannot exceed 10 digits';
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
      _credentialError = 'Please enter your mobile number';
      valid = false;
    } else {
      final digitsOnly = _credential.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 10) {
        _credentialError = 'Enter a valid 10-digit mobile number';
        valid = false;
      } else if (digitsOnly.length > 10) {
        _credentialError = 'Mobile number cannot exceed 10 digits';
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
  /// On failure, sets [apiError], [credentialError] or [passwordError].
  Future<bool> submit() async {
    if (!_validate()) return false;

    _isLoading = true;
    _apiError = null;
    notifyListeners();

    try {
      // Only phone + password is supported by the API right now.
      // OTP mode will hit the same endpoint once OTP sending is wired up.
      final authResponse = await AuthService.loginWithPassword(
        phone: _credential.trim(),
        password: _password,
      );

      // Save initial session to provide token for the profile fetch
      await SessionManager.instance.saveSession(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
        user: authResponse.user,
      );

      // Immediately fetch the full profile to get roles and permissions
      final detailedUser = await AuthService.getUserProfile(authResponse.user.id);
      
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
