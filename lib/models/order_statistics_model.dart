class OrderStatistics {
  final int totalOrders;
  final int pending;
  final int confirmed;
  final int delivered;
  final int shipped;
  final int partiallyDelivered;
  final int returned;
  final int cancelled;

  OrderStatistics({
    required this.totalOrders,
    required this.pending,
    required this.confirmed,
    required this.delivered,
    required this.shipped,
    required this.partiallyDelivered,
    required this.returned,
    required this.cancelled,
  });

  factory OrderStatistics.fromJson(Map<String, dynamic> json) {
    return OrderStatistics(
      totalOrders: json['total_orders'] ?? 0,
      pending: json['pending'] ?? 0,
      confirmed: json['confirmed'] ?? 0,
      delivered: json['delivered'] ?? 0,
      shipped: json['shipped'] ?? 0,
      partiallyDelivered: json['partially_delivered'] ?? 0,
      returned: json['returned'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }

  // Helper factory for dummy/empty state
  factory OrderStatistics.empty() {
    return OrderStatistics(
      totalOrders: 0,
      pending: 0,
      confirmed: 0,
      delivered: 0,
      shipped: 0,
      partiallyDelivered: 0,
      returned: 0,
      cancelled: 0,
    );
  }
}
