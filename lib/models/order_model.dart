enum OrderStatus { pending, inProgress, completed, delayed, cancelled }

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.delayed:
        return 'Delayed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderModel {
  final String id;
  final String customerName;
  final String customerInitials;
  final String garmentType;
  final double amount;
  final OrderStatus status;
  final DateTime dueDate;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.customerInitials,
    required this.garmentType,
    required this.amount,
    required this.status,
    required this.dueDate,
  });

  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) && status != OrderStatus.completed;

  static List<OrderModel> dummyOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 'ORD-001',
        customerName: 'Arjun Mehta',
        customerInitials: 'AM',
        garmentType: 'Sherwani',
        amount: 8500,
        status: OrderStatus.delayed,
        dueDate: now.subtract(const Duration(days: 2)),
      ),
      OrderModel(
        id: 'ORD-002',
        customerName: 'Priya Sharma',
        customerInitials: 'PS',
        garmentType: 'Lehenga Blouse',
        amount: 3200,
        status: OrderStatus.inProgress,
        dueDate: now.add(const Duration(days: 3)),
      ),
      OrderModel(
        id: 'ORD-003',
        customerName: 'Rahul Kapoor',
        customerInitials: 'RK',
        garmentType: 'Suit (3-piece)',
        amount: 12000,
        status: OrderStatus.completed,
        dueDate: now.subtract(const Duration(days: 1)),
      ),
      OrderModel(
        id: 'ORD-004',
        customerName: 'Sneha Patel',
        customerInitials: 'SP',
        garmentType: 'Anarkali Suit',
        amount: 4800,
        status: OrderStatus.delayed,
        dueDate: now.subtract(const Duration(days: 4)),
      ),
      OrderModel(
        id: 'ORD-005',
        customerName: 'Vikram Singh',
        customerInitials: 'VS',
        garmentType: 'Bandhgala Coat',
        amount: 6500,
        status: OrderStatus.pending,
        dueDate: now.add(const Duration(days: 5)),
      ),
      OrderModel(
        id: 'ORD-006',
        customerName: 'Kavya Nair',
        customerInitials: 'KN',
        garmentType: 'Saree Blouse',
        amount: 1800,
        status: OrderStatus.completed,
        dueDate: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
