import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/customer_list_response.dart';

enum ClientTier { vip, premium, standard }

class ClientsProvider extends ChangeNotifier {
  final List<CustomerListItem> _customers = [];
  List<CustomerListItem> get customers => List.unmodifiable(_customers);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;

  int get totalCount => _totalCount;
  bool get hasMore => _currentPage < _totalPages;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> fetchCustomers({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _customers.clear();
    }

    if (_isLoading) return;

    _isLoading = true;
    if (!refresh) notifyListeners(); // Only notify if not refreshing (UI might handle refresh indicator)

    try {
      final responseMap = await AuthService.getAllCustomers(
        page: _currentPage,
        limit: 10,
      );
      
      final response = CustomerListResponse.fromJson(responseMap);
      
      if (refresh) {
        _customers.clear();
      }
      
      _customers.addAll(response.data);
      _totalPages = response.totalPages;
      _totalCount = response.totalCount;
      _currentPage = response.currentPage;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final responseMap = await AuthService.getAllCustomers(
        page: nextPage,
        limit: 10,
      );
      
      final response = CustomerListResponse.fromJson(responseMap);
      
      _customers.addAll(response.data);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    // For now, let's keep local search or we could implement backend search
    notifyListeners();
  }

  List<CustomerListItem> get filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    final lowerQuery = _searchQuery.toLowerCase();
    return _customers.where((customer) {
      return customer.fullName.toLowerCase().contains(lowerQuery) ||
             customer.phoneNumber.contains(lowerQuery);
    }).toList();
  }
}
