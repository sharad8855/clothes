import 'package:flutter/foundation.dart';

/// Login input mode: Mobile number or Email address
enum LoginInputMode { mobile, email }

/// Authentication mode: Password or OTP
enum AuthMode { password, otp }

/// State for the Login Screen
class LoginProvider extends ChangeNotifier {
  // ─── Tab state ───────────────────────────────────────────────
  LoginInputMode _inputMode = LoginInputMode.mobile;
  LoginInputMode get inputMode => _inputMode;

  void setInputMode(LoginInputMode mode) {
    if (_inputMode == mode) return;
    _inputMode = mode;
    _credential = '';
    _credentialError = null;
    notifyListeners();
  }

  // ─── Auth mode (Password vs OTP) ─────────────────────────────
  AuthMode _authMode = AuthMode.password;
  AuthMode get authMode => _authMode;

  void toggleAuthMode() {
    _authMode =
        _authMode == AuthMode.password ? AuthMode.otp : AuthMode.password;
    _password = '';
    _passwordError = null;
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

  // ─── Loading state ───────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Validation ──────────────────────────────────────────────
  bool _validate() {
    bool valid = true;

    if (_credential.trim().isEmpty) {
      _credentialError = _inputMode == LoginInputMode.mobile
          ? 'Please enter your mobile number'
          : 'Please enter your email address';
      valid = false;
    } else if (_inputMode == LoginInputMode.mobile) {
      final digitsOnly = _credential.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 10) {
        _credentialError = 'Enter a valid 10-digit mobile number';
        valid = false;
      }
    } else {
      final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$');
      if (!emailRegex.hasMatch(_credential.trim())) {
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
    notifyListeners();

    // Simulate network call — replace with real API later
    await Future.delayed(const Duration(milliseconds: 1500));

    _isLoading = false;
    notifyListeners();

    // TODO: Replace with real auth result
    return true;
  }
}
