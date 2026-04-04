import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  confirmed,
  ready,
  delivered,
  inProgress,
  delayed,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending: return 'PENDING';
      case OrderStatus.confirmed: return 'CONFIRMED';
      case OrderStatus.ready: return 'READY';
      case OrderStatus.delivered: return 'DELIVERED';
      case OrderStatus.inProgress: return 'IN PROGRESS';
      case OrderStatus.delayed: return 'DELAYED';
      case OrderStatus.cancelled: return 'CANCELLED';
    }
  }
}

class OrderItem {
  final String id;
  final String customerName;
  final String itemDescription;
  final String date;
  final OrderStatus status;
  final IconData garmentIcon;
  final String? assignedStaff;

  OrderItem({
    required this.id,
    required this.customerName,
    required this.itemDescription,
    required this.date,
    required this.status,
    required this.garmentIcon,
    this.assignedStaff,
  });
}
