import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  UserModel? _userProfile;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  UserModel? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final sessionUser = await SessionManager.instance.getUser();
      if (sessionUser == null) {
        throw Exception('User session not found.');
      }

      final fetchedProfile = await AuthService.getUserProfile(sessionUser.id);
      _userProfile = fetchedProfile;
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
