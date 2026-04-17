import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/order_statistics_model.dart';
import '../models/financial_summary_model.dart';
import '../models/order_list_response.dart';
import '../models/customer_list_response.dart';
import '../services/auth_service.dart';
import '../core/session_manager.dart';

class HomeProvider extends ChangeNotifier {
  // ─── Tailor Info ─────────────────────────────────────────────
  final String tailorName = 'Master Tailor';
  final String studioName = 'The Bespoke Atelier';

  // ─── AI Insights banner ───────────────────────────────────────
  bool _showInsightsBanner = true;
  bool get showInsightsBanner => _showInsightsBanner;

  void dismissInsightsBanner() {
    _showInsightsBanner = false;
    notifyListeners();
  }

  // ─── Customer Cache ──────────────────────────────────────────
  final Map<String, String> _customerNames = {};

  String getCustomerName(String customerId) {
    return _customerNames[customerId] ?? 'Unknown Customer';
  }

  Future<void> _preloadCustomerNames() async {
    try {
      final responseMap = await AuthService.getAllCustomers(page: 1, limit: 100);
      final response = CustomerListResponse.fromJson(responseMap);
      for (var customer in response.data) {
        _customerNames[customer.id] = customer.fullName;
      }
    } catch (e) {
      if (kDebugMode) print('Error preloading customers: $e');
    }
  }

  // ─── Orders ───────────────────────────────────────────────────
  final List<OrderModel> _orders = OrderModel.dummyOrders();
  List<OrderListItem> _realRecentOrders = [];
  
  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderListItem> get recentOrders => _realRecentOrders;

  int get totalOrders => _statistics?.totalOrders ?? _orders.length;

  int get pendingOrders => _statistics?.pending ?? _orders
      .where((o) =>
          o.status == OrderStatus.pending || o.status == OrderStatus.inProgress)
      .length;

  int get completedOrders => _statistics?.delivered ??
      _orders.where((o) => o.status == OrderStatus.completed).length;

  int get delayedOrders =>
      _orders.where((o) => o.status == OrderStatus.delayed).length;

  int get totalClients => _statistics?.totalOrders ?? _orders
      .map((o) => o.customerName)
      .toSet()
      .length;

  // ─── Statistics ───────────────────────────────────────────────
  OrderStatistics? _statistics;
  OrderStatistics? get statistics => _statistics;

  Future<void> fetchStatistics() async {
    try {
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      _statistics = await AuthService.getOrderStatistics(businessId: bizId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error fetching statistics: $e');
    }
  }

  // ─── Financial Summary (KPI Reporting) ─────────────────────────────────────
  FinancialSummary? _financialSummary;
  FinancialSummary? get financialSummary => _financialSummary;

  Future<void> fetchFinancialSummary() async {
    try {
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      _financialSummary = await AuthService.getFinancialSummary(businessId: bizId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error fetching financial summary: $e');
    }
  }

  Future<void> fetchRecentOrders() async {
    try {
      final user = await SessionManager.instance.getUser();
      final bizId = await SessionManager.instance.getSelectedBusinessId();
      
      final response = await AuthService.getOrdersList(
        page: 1, 
        limit: 10,
        userId: user?.id,
        businessId: bizId,
      );
      _realRecentOrders = response.data;
      
      // Auto-populate names from cache
      for (var order in _realRecentOrders) {
        final cachedName = _customerNames[order.customerId];
        if (cachedName != null) {
          order.setCachedCustomerName(cachedName);
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error fetching recent orders: $e');
    }
  }

  // ─── Financials ───────────────────────────────────────────────
  double get totalCollected => _financialSummary?.totalPaid ?? _orders
      .where((o) => o.status == OrderStatus.completed)
      .fold(0.0, (sum, o) => sum + o.amount);

  double get totalPending => _financialSummary?.totalOutstanding ?? _orders
      .where((o) => o.status != OrderStatus.completed &&
          o.status != OrderStatus.cancelled)
      .fold(0.0, (sum, o) => sum + o.amount);

  double get monthlyRevenue => _financialSummary?.totalRevenue ?? 18450.0;

  double get revenueProgress {
    if (monthlyRevenue == 0) return 0.0;
    return (totalCollected / monthlyTarget).clamp(0.0, 1.0);
  }

  double get monthlyTarget => 27500.0;

  // ─── Bottom nav ───────────────────────────────────────────────
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  void setNavIndex(int index) {
    if (_selectedNavIndex == index) return;
    _selectedNavIndex = index;
    notifyListeners();
  }

  // ─── Loading / refresh ────────────────────────────────────────
  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();
    
    // Fetch real data
    await Future.wait([
      fetchStatistics(),
      fetchFinancialSummary(),
      fetchRecentOrders(),
      _preloadCustomerNames(),
    ]);
    
    // Simulated delay for other things
    await Future.delayed(const Duration(milliseconds: 1200));
    
    _isRefreshing = false;
    notifyListeners();
  }
}
