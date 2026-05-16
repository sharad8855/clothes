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
      debugPrint("Fetching staff...");
      final response = await AuthService.getBusinessStaff(page: 1, limit: 100);
      debugPrint("Staff response success: \${response.success}, count: \${response.data.length}");
      if (response.success) {
        _staffList = response.data;
      } else {
        _error = response.message;
        debugPrint("Staff response error: \$_error");
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("Staff fetch error: \$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
