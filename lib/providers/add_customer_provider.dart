import 'package:flutter/material.dart';

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

  String _emailAddress = '';
  String get emailAddress => _emailAddress;

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
    notifyListeners();
  }

  void setEmailAddress(String value) {
    _emailAddress = value;
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

    _isLoading = true;
    notifyListeners();

    // Mock API call
    await Future.delayed(const Duration(milliseconds: 1500));

    _isLoading = false;
    notifyListeners();
    return true;
  }
}
