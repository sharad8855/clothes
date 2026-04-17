class BusinessModel {
  final String id;
  final String name;
  final String? description;
  final String officeStartTime;
  final String officeEndTime;
  final List<String> workingDays;
  final String userId;
  final String clientId;
  final BusinessContactInfo? contactInfo;
  final List<BusinessOwnerDetail>? ownerDetails;

  BusinessModel({
    required this.id,
    required this.name,
    this.description,
    this.officeStartTime = '09:00:00',
    this.officeEndTime = '18:00:00',
    this.workingDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    required this.userId,
    required this.clientId,
    this.contactInfo,
    this.ownerDetails,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    // The API might return the details directly or nested in a 'business' field
    final businessJson = json['id'] != null ? json : json['business'] ?? json;

    var ownerDetailsJson = businessJson['owner_details'] as List?;
    List<BusinessOwnerDetail>? owners = ownerDetailsJson != null
        ? ownerDetailsJson.map((o) => BusinessOwnerDetail.fromJson(o)).toList()
        : null;

    return BusinessModel(
      id: businessJson['id'] as String? ?? '',
      name: businessJson['name'] as String? ?? '',
      description: businessJson['description'] as String?,
      officeStartTime: businessJson['office_start_time'] as String? ?? '09:00:00',
      officeEndTime: businessJson['office_end_time'] as String? ?? '18:00:00',
      workingDays: List<String>.from(businessJson['working_days'] ?? []),
      userId: businessJson['user_id'] as String? ?? '',
      clientId: businessJson['client_id'] as String? ?? '',
      contactInfo: businessJson['contact_info'] != null
          ? BusinessContactInfo.fromJson(businessJson['contact_info'])
          : null,
      ownerDetails: owners,
    );
  }

  Map<String, dynamic> toJsonForCreation() => {
        "business": {
          "name": name,
          "description": description ?? '',
          "office_start_time": officeStartTime,
          "office_end_time": officeEndTime,
          "working_days": workingDays,
          "non_working_days": _getNonWorkingDays(),
          "user_id": userId,
          "client_id": clientId,
          "custom_fields": {},
        },
        "contactInfo": contactInfo?.toJson() ?? {},
        "business_tags": [],
        "business_category_ids": ["6861dee5-76bf-49ea-a9db-7a842ea86bdd"],
        "business_sub_category_ids": [],
        "owner_details": ownerDetails != null && ownerDetails!.isNotEmpty
            ? ownerDetails!.first.toJson()
            : {},
      };

  List<String> _getNonWorkingDays() {
    const allDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return allDays.where((day) => !workingDays.contains(day)).toList();
  }
}

class BusinessContactInfo {
  final String? id;
  final String address;
  final String pincode;
  final String city;
  final String state;
  final String country;
  final String phone;
  final String? email;
  final String? website;

  BusinessContactInfo({
    this.id,
    required this.address,
    required this.pincode,
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    this.email,
    this.website,
  });

  factory BusinessContactInfo.fromJson(Map<String, dynamic> json) {
    return BusinessContactInfo(
      id: json['id'] as String?,
      address: json['address'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? 'India',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      website: json['business_website'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "address": address,
        "pincode": pincode,
        "city": city,
        "state": state,
        "country": country,
        "phone": phone,
        "email": email ?? '',
        "business_website": website ?? '',
        "business_instagram": "",
        "business_facebook": "",
        "custom_fields": {},
      };
}

class BusinessOwnerDetail {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;

  BusinessOwnerDetail({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.gender = 'Female',
  });

  factory BusinessOwnerDetail.fromJson(Map<String, dynamic> json) {
    return BusinessOwnerDetail(
      id: json['id'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Female',
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "gender": gender,
      };
}
