import 'package:flutter/material.dart';

enum OrderStatus { inProgress, pending, ready, delivered }

class OrderItem {
  final String id;
  final String customerName;
  final String itemDescription;
  final String date;
  final OrderStatus status;
  final bool isHighPriority;
  final IconData garmentIcon;
  final String? aiSuggestion;
  final String? assignedStaff;
  final List<String> assignedAvatarInitials;

  const OrderItem({
    required this.id,
    required this.customerName,
    required this.itemDescription,
    required this.date,
    required this.status,
    required this.garmentIcon,
    this.isHighPriority = false,
    this.aiSuggestion,
    this.assignedStaff,
    this.assignedAvatarInitials = const [],
  });
}

class OrderManagementProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  double get dailyEfficiency => 94.0;
  int get readyItemsCount => 3;

  final List<OrderItem> _allOrders = [
    OrderItem(
      id: '#ORD-8829',
      customerName: 'Alexander Rossi',
      itemDescription: 'Three-piece Tuxedo',
      date: 'Oct 12, 2023',
      status: OrderStatus.pending,
      garmentIcon: Icons.dry_cleaning_rounded,
      assignedStaff: 'Julian Thorne',
    ),
    OrderItem(
      id: '#ORD-8830',
      customerName: 'Julianne Moore',
      itemDescription: 'Wool Overcoat',
      date: 'Oct 15, 2023',
      status: OrderStatus.inProgress,
      garmentIcon: Icons.content_cut_rounded,
      assignedStaff: 'Elena Moretti',
    ),
    OrderItem(
      id: '#ORD-8831',
      customerName: 'Sebastian Vane',
      itemDescription: 'Linen Summer Suit',
      date: 'Oct 08, 2023',
      status: OrderStatus.ready,
      garmentIcon: Icons.check_circle_outline_rounded,
      assignedStaff: 'Arthur Vance',
    ),
  ];

  List<OrderItem> get filteredOrders {
    if (_searchQuery.isEmpty) return _allOrders;
    final q = _searchQuery.toLowerCase();
    return _allOrders.where((o) =>
      o.customerName.toLowerCase().contains(q) ||
      o.id.toLowerCase().contains(q) ||
      o.itemDescription.toLowerCase().contains(q)
    ).toList();
  }

  OrderItem get featuredOrder => _allOrders.first;
  List<OrderItem> get listOrders => filteredOrders.skip(1).toList();

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addOrder(OrderItem order) {
    _allOrders.insert(0, order); // Add to top of the list
    notifyListeners();
  }

  String statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.inProgress: return 'In Progress';
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.ready: return 'Ready';
      case OrderStatus.delivered: return 'Delivered';
    }
  }

  Color statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.inProgress: return const Color(0xFF5B4FCF);
      case OrderStatus.pending: return const Color(0xFFF59E0B);
      case OrderStatus.ready: return const Color(0xFF10B981);
      case OrderStatus.delivered: return const Color(0xFF6B7280);
    }
  }

  Color statusBgColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.inProgress: return const Color(0xFFEDE9FE);
      case OrderStatus.pending: return const Color(0xFFFEF3C7);
      case OrderStatus.ready: return const Color(0xFFD1FAE5);
      case OrderStatus.delivered: return const Color(0xFFF3F4F6);
    }
  }
}
