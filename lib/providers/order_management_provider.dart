import 'package:flutter/material.dart';
import '../models/order_list_response.dart';
import '../models/customer_list_response.dart';
import '../models/order_legacy_model.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

class OrderManagementProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Real data states
  List<OrderListItem> _orders = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 10;
  int _totalCount = 0;

  List<OrderListItem> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  int get totalCount => _totalCount;

  // ─── Customer Cache ──────────────────────────────────────────
  final Map<String, String> _customerNames = {};

  String getCustomerName(String customerId) {
    return _customerNames[customerId] ?? 'Unknown Customer';
  }

  Future<void> _preloadCustomerNames() async {
    try {
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      final responseMap = await AuthService.getAllCustomers(
        page: 1, 
        limit: 100, 
        businessId: bizId,
      );
      final response = CustomerListResponse.fromJson(responseMap);
      for (var customer in response.data) {
        _customerNames[customer.id] = customer.fullName;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error preloading customer names: $e");
    }
  }

  String _selectedStatusFilter = 'All';
  String get selectedStatusFilter => _selectedStatusFilter;

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  double get dailyEfficiency => 94.0;
  int get readyItemsCount => _orders.where((o) => o.orderStatus.toLowerCase() == 'ready').length;

  List<OrderListItem> get filteredOrders {
    List<OrderListItem> result = _orders;

    if (_selectedStatusFilter != 'All') {
      result = result.where((o) => o.orderStatus.toLowerCase() == _selectedStatusFilter.toLowerCase()).toList();
    }

    if (_searchQuery.isEmpty) return result;
    
    final q = _searchQuery.toLowerCase();
    return result.where((o) =>
      o.customerName.toLowerCase().contains(q) ||
      o.billNumber.toLowerCase().contains(q) ||
      o.firstItemName.toLowerCase().contains(q)
    ).toList();
  }

  // Fetch initial orders or refresh
  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      if (_orders.isEmpty) {
        _isLoading = true;
        notifyListeners();
      }
    } else {
      if (_isLoading || !_hasMore) return;
      _isLoading = true;
      notifyListeners();
    }

    try {
      // Preload customers once on first load or refresh
      if (_customerNames.isEmpty || refresh) {
        await _preloadCustomerNames();
      }

      final user = await SessionManager.instance.getUser();
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      
      final response = await AuthService.getOrdersList(
        page: _currentPage,
        limit: _limit,
        businessId: bizId,
      );

      if (refresh) {
        _orders = response.data;
      } else {
        _orders.addAll(response.data);
      }

      // Pre-map names from cache
      for (var order in response.data) {
        final cachedName = _customerNames[order.customerId];
        if (cachedName != null) {
          order.setCachedCustomerName(cachedName);
        }
      }

      _totalCount = response.totalCount;
      _hasMore = _currentPage < response.totalPages;
      _currentPage++;
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more for infinite scroll
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      
      final response = await AuthService.getOrdersList(
        page: _currentPage,
        limit: _limit,
        businessId: bizId,
      );

      _orders.addAll(response.data);

      // Pre-map names from cache
      for (var order in response.data) {
        final cachedName = _customerNames[order.customerId];
        if (cachedName != null) {
          order.setCachedCustomerName(cachedName);
        }
      }

      _totalCount = response.totalCount;
      _hasMore = _currentPage < response.totalPages;
      _currentPage++;
    } catch (e) {
      debugPrint("Error loading more orders: $e");
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Helper for status formatting
  String statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return 'Pending';
      case 'confirmed': return 'Confirmed';
      case 'ready': return 'Ready';
      case 'delivered': return 'Delivered';
      default: return status;
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return const Color(0xFFB45309);
      case 'confirmed': return const Color(0xFF2563EB);
      case 'ready': return const Color(0xFF6366F1);
      case 'delivered': return const Color(0xFF64748B);
      default: return const Color(0xFF64748B);
    }
  }

  Color statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return const Color(0xFFFEF3C7);
      case 'confirmed': return const Color(0xFFDBEAFE);
      case 'ready': return const Color(0xFFE0E7FF);
      case 'delivered': return const Color(0xFFF1F5F9);
      default: return const Color(0xFFF1F5F9);
    }
  }

  void addOrder(OrderItem order) {
    // Note: This is a legacy method to keep AddOrderScreen working.
    debugPrint("Adding legacy order: ${order.id}");
    notifyListeners();
  }
}
