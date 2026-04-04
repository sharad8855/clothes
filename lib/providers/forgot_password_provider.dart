import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

enum ForgotPasswordStep { phone, otp, reset }

class ForgotPasswordProvider extends ChangeNotifier {
  ForgotPasswordStep _currentStep = ForgotPasswordStep.phone;
  ForgotPasswordStep get currentStep => _currentStep;

  String _phone = '';
  String get phone => _phone;

  String _otp = '';
  String get otp => _otp;

  String _token = '';
  String get token => _token;

  String _newPassword = '';
  String get newPassword => _newPassword;

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;

  String? _phoneError;
  String? get phoneError => _phoneError;

  String? _otpError;
  String? get otpError => _otpError;

  String? _newPasswordError;
  String? get newPasswordError => _newPasswordError;

  String? _confirmPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _apiError;
  String? get apiError => _apiError;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _confirmPasswordVisible = false;
  bool get confirmPasswordVisible => _confirmPasswordVisible;

  void setPhone(String value) {
    _phone = value;
    _phoneError = null;
    _apiError = null;
    notifyListeners();
  }

  void setOtp(String value) {
    _otp = value;
    _otpError = null;
    _apiError = null;
    notifyListeners();
  }

  void setNewPassword(String value) {
    _newPassword = value;
    _newPasswordError = null;
    _apiError = null;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _confirmPasswordError = null;
    _apiError = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  void backToStart() {
    _currentStep = ForgotPasswordStep.phone;
    _otp = '';
    _token = '';
    _newPassword = '';
    _confirmPassword = '';
    _apiError = null;
    notifyListeners();
  }

  Future<void> submitField() async {
    _apiError = null;
    notifyListeners();

    switch (_currentStep) {
      case ForgotPasswordStep.phone:
        await _requestOtp();
        break;
      case ForgotPasswordStep.otp:
        await _verifyOtp();
        break;
      case ForgotPasswordStep.reset:
        await _resetPassword();
        break;
    }
  }

  Future<void> _requestOtp() async {
    if (_phone.trim().isEmpty) {
      _phoneError = 'Please enter your phone number';
      notifyListeners();
      return;
    }
    
    final digitsOnly = _phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      _phoneError = 'Enter a valid 10-digit mobile number';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await AuthService.requestPasswordResetOtp(_phone.trim());
      if (success) {
        _currentStep = ForgotPasswordStep.otp;
      }
    } on AuthException catch (e) {
      _apiError = e.message;
    } catch (e) {
      _apiError = 'Unexpected error occurred.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.trim().isEmpty) {
      _otpError = 'Please enter the OTP';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final receivedToken = await AuthService.verifyPasswordResetOtp(
        phone: _phone.trim(),
        otp: _otp.trim(),
      );
      _token = receivedToken;
      _currentStep = ForgotPasswordStep.reset;
    } on AuthException catch (e) {
      _apiError = e.message;
    } catch (e) {
      _apiError = 'Unexpected error verifying OTP.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _resetPassword() async {
    bool valid = true;

    if (_newPassword.isEmpty) {
      _newPasswordError = 'Please enter a new password';
      valid = false;
    } else if (_newPassword.length < 6) {
      _newPasswordError = 'Password must be at least 6 characters';
      valid = false;
    }

    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = 'Please confirm your new password';
      valid = false;
    } else if (_newPassword != _confirmPassword) {
      _confirmPasswordError = 'Passwords do not match';
      valid = false;
    }

    if (!valid) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await AuthService.resetPassword(
        token: _token,
        newPassword: _newPassword,
        confirmPassword: _confirmPassword,
      );

      if (success) {
        _isSuccess = true;
      } else {
        _apiError = 'Password reset failed.';
      }
    } on AuthException catch (e) {
      _apiError = e.message;
    } catch (e) {
      _apiError = 'Unexpected error. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
