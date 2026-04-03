import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

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

  // ─── Orders ───────────────────────────────────────────────────
  final List<OrderModel> _orders = OrderModel.dummyOrders();
  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get recentOrders => _orders.take(4).toList();

  int get totalOrders => _orders.length;

  int get pendingOrders => _orders
      .where((o) =>
          o.status == OrderStatus.pending || o.status == OrderStatus.inProgress)
      .length;

  int get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.completed).length;

  int get delayedOrders =>
      _orders.where((o) => o.status == OrderStatus.delayed).length;

  int get totalClients => _orders
      .map((o) => o.customerName)
      .toSet()
      .length;

  // ─── Financials ───────────────────────────────────────────────
  double get totalCollected => _orders
      .where((o) => o.status == OrderStatus.completed)
      .fold(0.0, (sum, o) => sum + o.amount);

  double get totalPending => _orders
      .where((o) => o.status != OrderStatus.completed &&
          o.status != OrderStatus.cancelled)
      .fold(0.0, (sum, o) => sum + o.amount);

  double get monthlyRevenue => 18450.0; // mock monthly figure

  double get revenueProgress => 0.67; // 67% of monthly target
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
    await Future.delayed(const Duration(milliseconds: 1200));
    _isRefreshing = false;
    notifyListeners();
  }
}
