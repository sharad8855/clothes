class FinancialSummary {
  final int totalOrders;
  final double totalRevenue;
  final double totalPaid;
  final double totalOutstanding;

  FinancialSummary({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalPaid,
    required this.totalOutstanding,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalOrders: json['total_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0.0).toDouble(),
      totalPaid: (json['total_paid'] ?? 0.0).toDouble(),
      totalOutstanding: (json['total_outstanding'] ?? 0.0).toDouble(),
    );
  }

  factory FinancialSummary.empty() {
    return FinancialSummary(
      totalOrders: 0,
      totalRevenue: 0.0,
      totalPaid: 0.0,
      totalOutstanding: 0.0,
    );
  }
}
