class CustomerListItem {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String phoneNumber;
  final String countryCode;
  final String? billNumber;

  CustomerListItem({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    required this.phoneNumber,
    required this.countryCode,
    this.billNumber,
  });

  String get fullName {
    if ((firstName == null || firstName!.isEmpty) && 
        (lastName == null || lastName!.isEmpty)) {
      return "Client $phoneNumber";
    }
    return "${firstName ?? ''} ${lastName ?? ''}".trim();
  }

  String get initials {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return "${firstName![0]}${lastName![0]}".toUpperCase();
      }
      return firstName![0].toUpperCase();
    }
    return "?";
  }

  factory CustomerListItem.fromJson(Map<String, dynamic> json) {
    return CustomerListItem(
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '+91',
      billNumber: json['bill_number'] as String?,
    );
  }
}

class CustomerListResponse {
  final bool success;
  final String message;
  final List<CustomerListItem> data;
  final int totalCount;
  final int currentPage;
  final int limit;
  final int totalPages;

  CustomerListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.currentPage,
    required this.limit,
    required this.totalPages,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CustomerListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['total_count'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['total_pages'] as int? ?? 0,
    );
  }
}
