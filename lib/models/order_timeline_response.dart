class OrderTimelineResponse {
  final bool success;
  final String message;
  final List<OrderTimelineItem> data;

  OrderTimelineResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderTimelineResponse.fromJson(Map<String, dynamic> json) {
    return OrderTimelineResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => OrderTimelineItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderTimelineItem {
  final String id;
  final String orderId;
  final String status;
  final DateTime timestamp;
  final String? notes;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderTimelineItem({
    required this.id,
    required this.orderId,
    required this.status,
    required this.timestamp,
    this.notes,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderTimelineItem.fromJson(Map<String, dynamic> json) {
    return OrderTimelineItem(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? 'unknown',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      notes: json['notes'],
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
