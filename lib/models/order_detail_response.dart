import 'order_list_response.dart';

class OrderDetailResponse {
  final bool success;
  final String message;
  final OrderListItem data;

  OrderDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OrderListItem.fromJson(json['data'] ?? {}),
    );
  }
}

// Since OrderListItem already covers most fields, I'll update the original OrderCustomer model 
// in order_list_response.dart if needed, or define a more complex one here.
// Let's create a specific DetailCustomer for the addresses.

class DetailCustomer extends OrderCustomer {
  final Address? billingAddress;
  final Address? shippingAddress;
  final String? countryCode;

  DetailCustomer({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.email,
    this.billingAddress,
    this.shippingAddress,
    this.countryCode,
  });

  factory DetailCustomer.detailed(Map<String, dynamic> json) {
    return DetailCustomer(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      countryCode: json['country_code'],
      billingAddress: json['billing_address'] != null ? Address.fromJson(json['billing_address']) : null,
      shippingAddress: json['shipping_address'] != null ? Address.fromJson(json['shipping_address']) : null,
    );
  }
}

class Address {
  final String city;
  final String state;
  final String street;
  final String country;
  final String village;
  final String houseNo;
  final String locality;
  final String zipCode;

  Address({
    required this.city,
    required this.state,
    required this.street,
    required this.country,
    required this.village,
    required this.houseNo,
    required this.locality,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      street: json['street'] ?? '',
      country: json['country'] ?? '',
      village: json['village'] ?? '',
      houseNo: json['house_no'] ?? '',
      locality: json['locality'] ?? '',
      zipCode: json['zip_code'] ?? '',
    );
  }
}
