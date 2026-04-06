class BusinessStaffResponse {
  final bool success;
  final String message;
  final List<BusinessStaff> data;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final int limit;

  BusinessStaffResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });

  factory BusinessStaffResponse.fromJson(Map<String, dynamic> json) {
    return BusinessStaffResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BusinessStaff.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['total_count'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }
}

class BusinessStaff {
  final String id;
  final String businessId;
  final String userId;
  final String? serviceId;
  final StaffUser user;
  final StaffService? service;
  final int assignedOrderCount;

  BusinessStaff({
    required this.id,
    required this.businessId,
    required this.userId,
    this.serviceId,
    required this.user,
    this.service,
    required this.assignedOrderCount,
  });

  factory BusinessStaff.fromJson(Map<String, dynamic> json) {
    return BusinessStaff(
      id: json['id'] as String? ?? '',
      businessId: json['business_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      serviceId: json['service_id'] as String?,
      user: StaffUser.fromJson(json['user'] as Map<String, dynamic>),
      service: json['service'] != null
          ? StaffService.fromJson(json['service'] as Map<String, dynamic>)
          : null,
      assignedOrderCount: json['assigned_order_count'] as int? ?? 0,
    );
  }
}

class StaffUser {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  StaffUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory StaffUser.fromJson(Map<String, dynamic> json) {
    return StaffUser(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

class StaffService {
  final String serviceId;
  final String serviceName;

  StaffService({
    required this.serviceId,
    required this.serviceName,
  });

  factory StaffService.fromJson(Map<String, dynamic> json) {
    return StaffService(
      serviceId: json['service_id'] as String? ?? '',
      serviceName: json['service_name'] as String? ?? '',
    );
  }
}
