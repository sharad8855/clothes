import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

class BusinessProvider with ChangeNotifier {
  bool _isLoading = false;
  List<BusinessModel> _businesses = [];
  BusinessModel? _selectedBusiness;
  String? _errorMessage;

  BusinessProvider() {
    fetchUserBusinesses();
  }

  // ── Creation Form State ────────────────────────────────────────────────────
  String? businessName;
  String? businessDescription;
  String startTime = '09:00:00';
  String endTime = '18:00:00';
  List<String> workingDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  String? address;
  String? pincode;
  String? city;
  String? state;
  String? phone;
  String? email;
  String? ownerFirstName;
  String? ownerLastName;

  // ── Getters ────────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  List<BusinessModel> get businesses => _businesses;
  BusinessModel? get selectedBusiness => _selectedBusiness;
  String? get errorMessage => _errorMessage;

  // ── Get Business API IDs (from curl) ───────────────────────────────────────
  // Client ID is automatically handled by AuthService.clientId
  static const String _apiBusinessId = '5308c246-9f59-4923-9c59-4e634a3fa8c8';

  // ── Fetch Businesses ───────────────────────────────────────────────────────
  Future<void> fetchUserBusinesses() async {
    _setLoading(true);
    _clearError();
    try {
      // 1. Fetch list from get-all endpoint
      final fetchedList = await AuthService.getBusinessesList();

      // 2. Fetch specific business from GET Business API
      BusinessModel? specificBusiness;
      try {
        specificBusiness = await AuthService.getBusinessDetails(_apiBusinessId);
      } catch (e) {
        debugPrint('Could not fetch specific business: $e');
      }

      // 3. Merge — insert specific business at top if not already in list
      final merged = List<BusinessModel>.from(fetchedList);
      if (specificBusiness != null &&
          !merged.any((b) => b.id == specificBusiness!.id)) {
        merged.insert(0, specificBusiness);
      }
      _businesses = merged;

      // 4. Restore previously selected business from session
      final savedId = await SessionManager.instance.getSelectedBusinessId();
      if (savedId != null && _businesses.isNotEmpty) {
        _selectedBusiness = _businesses.firstWhere(
          (b) => b.id == savedId,
          orElse: () => _businesses.first,
        );
      } else if (_businesses.length == 1) {
        await handleSelectBusiness(_businesses.first);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ── Select Business ────────────────────────────────────────────────────────
  Future<void> handleSelectBusiness(BusinessModel business) async {
    _selectedBusiness = business;
    await SessionManager.instance.saveSelectedBusinessId(business.id);
    notifyListeners();
  }

  // ── Create Business ────────────────────────────────────────────────────────
  Future<bool> createNewBusiness() async {
    _setLoading(true);
    _clearError();
    try {
      final user = await SessionManager.instance.getUser();
      if (user == null) throw Exception('User not found');

      final newBusiness = BusinessModel(
        id: '',
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
          ),
        ],
      );

      final created = await AuthService.createBusiness(newBusiness);
      _selectedBusiness = created;
      await SessionManager.instance.saveSelectedBusinessId(created.id);

      // Add to local list immediately for instant UI update
      if (!_businesses.any((b) => b.id == created.id)) {
        _businesses.insert(0, created);
        notifyListeners();
      }

      // Refresh in background — intentionally not awaited
      // ignore: discarded_futures
      fetchUserBusinesses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Internal Helpers ───────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Form Field Setters ─────────────────────────────────────────────────────
  void updateBasicInfo({
    required String name,
    required String desc,
    required String start,
    required String end,
  }) {
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
