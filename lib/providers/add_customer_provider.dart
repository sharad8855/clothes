import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

enum FitType { slim, regular }
enum PriorityLevel { standard, vip }

class AddCustomerProvider extends ChangeNotifier {
  // Add image logic
  String? _imagePath;
  String? get imagePath => _imagePath;

  void pickImage() {
    // Logic for picking image
    notifyListeners();
  }

  // Fields
  String _fullName = '';
  String get fullName => _fullName;

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  String? _phoneError;
  String? get phoneError => _phoneError;

  String _emailAddress = '';
  String get emailAddress => _emailAddress;

  String? _emailError;
  String? get emailError => _emailError;

  String _preferences = '';
  String get preferences => _preferences;

  FitType _typicalFit = FitType.slim;
  FitType get typicalFit => _typicalFit;

  PriorityLevel _priorityLevel = PriorityLevel.standard;
  PriorityLevel get priorityLevel => _priorityLevel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    // Extract only digits for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isNotEmpty && digitsOnly.length != 10) {
      _phoneError = 'Phone number must be exactly 10 digits';
    } else {
      _phoneError = null;
    }
    notifyListeners();
  }

  void setEmailAddress(String value) {
    _emailAddress = value;
    if (value.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      _emailError = 'Please enter a valid email address';
    } else {
      _emailError = null;
    }
    notifyListeners();
  }

  void setPreferences(String value) {
    _preferences = value;
    notifyListeners();
  }

  void setTypicalFit(FitType fit) {
    _typicalFit = fit;
    notifyListeners();
  }

  void setPriorityLevel(PriorityLevel level) {
    _priorityLevel = level;
    notifyListeners();
  }

  Future<bool> saveCustomer() async {
    if (_fullName.trim().isEmpty) return false;

    // Validate phone number
    final digitsOnly = _phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length != 10) {
      _phoneError = 'Phone number must be exactly 10 digits';
      notifyListeners();
      return false;
    }

    // Validate email
    if (_emailAddress.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(_emailAddress)) {
      _emailError = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      final success = await AuthService.createCustomer(
        fullName: _fullName,
        email: _emailAddress,
        phone: _phoneNumber,
        businessId: bizId,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
