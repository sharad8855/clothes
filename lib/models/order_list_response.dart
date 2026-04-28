import 'package:flutter/material.dart';

class OrderListResponse {
  final bool success;
  final String message;
  final List<OrderListItem> data;
  final int totalCount;
  final int currentPage;
  final int limit;
  final int totalPages;

  OrderListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.currentPage,
    required this.limit,
    required this.totalPages,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => OrderListItem.fromJson(item))
          .toList(),
      totalCount: json['total_count'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class OrderListItem {
  final String orderId;
  final String userId;
  final String clientId;
  final String? cartId;
  final String customerId;
  final String billNumber;
  final DateTime orderDate;
  final String paymentStatus;
  final String orderStatus;
  final String grandTotal;
  final DateTime updatedAt;
  final List<OrderItemDetail> orderItems;
  final CreatedByUser createdByUser;
  final OrderCustomer? customer;
  final DateTime dueDate;
  final String? notes;
  final String paidAmount;

  OrderListItem({
    required this.orderId,
    required this.userId,
    required this.clientId,
    this.cartId,
    required this.customerId,
    required this.billNumber,
    required this.orderDate,
    required this.paymentStatus,
    required this.orderStatus,
    required this.grandTotal,
    required this.updatedAt,
    required this.orderItems,
    required this.createdByUser,
    this.customer,
    required this.dueDate,
    this.notes,
    required this.paidAmount,
  });

  String? _cachedCustomerName;

  void setCachedCustomerName(String name) {
    _cachedCustomerName = name;
  }

  factory OrderListItem.fromJson(Map<String, dynamic> json) {
    return OrderListItem(
      orderId: json['order_id'] ?? '',
      userId: json['user_id'] ?? '',
      clientId: json['client_id'] ?? '',
      cartId: json['cart_id'],
      customerId: json['customer_id'] ?? '',
      billNumber: json['bill_number'] ?? '',
      orderDate: DateTime.tryParse(json['order_date'] ?? '') ?? DateTime.now(),
      paymentStatus: json['payment_status'] ?? '',
      orderStatus: json['order_status'] ?? '',
      grandTotal: json['grand_total'] ?? '0.00',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      orderItems: (json['order_items'] as List? ?? [])
          .map((item) => OrderItemDetail.fromJson(item))
          .toList(),
      createdByUser: CreatedByUser.fromJson(json['created_by_user'] ?? {}),
      customer: json['customer'] != null
          ? OrderCustomer.fromJson(json['customer'])
          : null,
      dueDate: DateTime.parse(json['due_date'] ?? json['order_date'] ?? DateTime.now().toIso8601String()),
      notes: json['notes'] as String?,
      paidAmount: json['paid_amount']?.toString() ?? '0.00',
    );
  }

  // UI Helpers
  String get customerName {
    if (_cachedCustomerName != null && _cachedCustomerName!.isNotEmpty) {
      return _cachedCustomerName!;
    }
    if (customer != null) {
      return "${customer!.firstName} ${customer!.lastName}".trim();
    }
    return "${createdByUser.firstName} ${createdByUser.lastName}".trim();
  }
  
  String get firstItemName {
    if (orderItems.isEmpty) return 'No items';
    return orderItems.first.product.name;
  }

  IconData get garmentIcon {
    final name = firstItemName.toLowerCase();
    if (name.contains('suit') || name.contains('tuxedo')) return Icons.checkroom_rounded;
    if (name.contains('shirt')) return Icons.dry_cleaning_rounded;
    if (name.contains('overcoat')) return Icons.layers_rounded;
    if (name.contains('notebook')) return Icons.edit_note_rounded;
    return Icons.shopping_bag_outlined;
  }

  Color get statusTextColor {
    switch (orderStatus.toLowerCase()) {
      case 'pending': return const Color(0xFFB45309);
      case 'confirmed': return const Color(0xFF2563EB);
      case 'ready': return const Color(0xFF6366F1);
      case 'delivered': return const Color(0xFF64748B);
      default: return const Color(0xFF64748B);
    }
  }

  Color get statusBgColor {
    switch (orderStatus.toLowerCase()) {
      case 'pending': return const Color(0xFFFEF3C7);
      case 'confirmed': return const Color(0xFFDBEAFE);
      case 'ready': return const Color(0xFFE0E7FF);
      case 'delivered': return const Color(0xFFF1F5F9);
      default: return const Color(0xFFF1F5F9);
    }
  }
}

class OrderItemDetail {
  final String itemId;
  final String productVariantId;
  final String? inventoryId;
  final int quantity;
  final String unitPrice;
  final String totalAmount;
  final Product product;

  OrderItemDetail({
    required this.itemId,
    required this.productVariantId,
    this.inventoryId,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.product,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      itemId: json['item_id'] ?? '',
      productVariantId: json['product_variant_id'] ?? '',
      inventoryId: json['inventory_id'],
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? '0.00',
      totalAmount: json['total_amount'] ?? '0.00',
      product: Product.fromJson(json['product'] ?? {}),
    );
  }
}

class Product {
  final String productId;
  final String name;
  final String? model;
  final String? sku;

  Product({
    required this.productId,
    required this.name,
    this.model,
    this.sku,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      model: json['model'],
      sku: json['sku'],
    );
  }
}

class CreatedByUser {
  final String id;
  final String firstName;
  final String lastName;

  CreatedByUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedByUser.fromJson(Map<String, dynamic> json) {
    return CreatedByUser(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

class OrderCustomer {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;

  OrderCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
  });

  factory OrderCustomer.fromJson(Map<String, dynamic> json) {
    return OrderCustomer(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
