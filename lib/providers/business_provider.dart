import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

class BusinessProvider with ChangeNotifier {
  bool _isLoading = false;
  List<BusinessModel> _businesses = [];
  BusinessModel? _selectedBusiness;
  String? _errorMessage;

  // Creation Form State
  String? businessName;
  String? businessDescription;
  String startTime = '09:00:00';
  String endTime = '18:00:00';
  List<String> workingDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  String? address;
  String? pincode;
  String? city;
  String? state;
  String? phone;
  String? email;
  String? ownerFirstName;
  String? ownerLastName;

  bool get isLoading => _isLoading;
  List<BusinessModel> get businesses => _businesses;
  BusinessModel? get selectedBusiness => _selectedBusiness;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserBusinesses() async {
    _setLoading(true);
    _clearError();
    try {
      final fetchedList = await AuthService.getBusinessesList();
      _businesses = fetchedList;
      
      // Try to reload the selected business from session
      final savedId = await SessionManager.instance.getSelectedBusinessId();
      if (savedId != null && _businesses.isNotEmpty) {
        _selectedBusiness = _businesses.firstWhere(
          (b) => b.id == savedId,
          orElse: () => _businesses.first,
        );
      } else if (_businesses.length == 1) {
        // Auto select if only one
        handleSelectBusiness(_businesses.first);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> handleSelectBusiness(BusinessModel business) async {
    _selectedBusiness = business;
    await SessionManager.instance.saveSelectedBusinessId(business.id);
    notifyListeners();
  }

  Future<bool> createNewBusiness() async {
    _setLoading(true);
    _clearError();
    try {
      final user = await SessionManager.instance.getUser();
      if (user == null) throw Exception('User not found');

      final newBusiness = BusinessModel(
        id: '', // Will be assigned by API
        name: businessName ?? '',
        description: businessDescription,
        officeStartTime: startTime,
        officeEndTime: endTime,
        workingDays: workingDays,
        userId: user.id,
        clientId: AuthService.clientId,
        contactInfo: BusinessContactInfo(
          address: address ?? '',
          pincode: pincode ?? '',
          city: city ?? '',
          state: state ?? '',
          country: 'India',
          phone: phone ?? user.phone,
          email: email ?? user.email,
        ),
        ownerDetails: [
          BusinessOwnerDetail(
            firstName: ownerFirstName ?? user.firstName,
            lastName: ownerLastName ?? user.lastName,
            email: email ?? user.email,
            phone: phone ?? user.phone,
          )
        ],
      );

      final created = await AuthService.createBusiness(newBusiness);
      _selectedBusiness = created;
      await SessionManager.instance.saveSelectedBusinessId(created.id);
      
      // Manually add to list to ensure immediate visibility
      if (!_businesses.any((b) => b.id == created.id)) {
        _businesses.insert(0, created);
      }
      
      // Still refresh list in background to sync with server
      fetchUserBusinesses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
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

  // Setters for form fields
  void updateBasicInfo({required String name, required String desc, required String start, required String end}) {
    businessName = name;
    businessDescription = desc;
    startTime = start;
    endTime = end;
    notifyListeners();
  }

  void updateContactInfo({
    required String addr, 
    required String pin, 
    required String cty, 
    required String st,
    required String ph,
    required String em,
    required String fName,
    required String lName,
  }) {
    address = addr;
    pincode = pin;
    city = cty;
    state = st;
    phone = ph;
    email = em;
    ownerFirstName = fName;
    ownerLastName = lName;
    notifyListeners();
  }
}
