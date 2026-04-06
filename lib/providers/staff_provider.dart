import 'package:flutter/material.dart';
import '../models/business_staff_response.dart';
import '../services/auth_service.dart';

class StaffProvider extends ChangeNotifier {
  List<BusinessStaff> _staffList = [];
  List<BusinessStaff> get staffList => _staffList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchStaff() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.getBusinessStaff(page: 1, limit: 100);
      if (response.success) {
        _staffList = response.data;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
