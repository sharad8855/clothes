/// Represents the logged-in user returned by the auth API.
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String status;
  final String? profileImage;
  final List<UserMapping> userMappings;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.status,
    this.profileImage,
    this.userMappings = const [],
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  /// Checks if the user has the 'Business Staff' role in any of their mappings.
  bool get isBusinessStaff {
    if (userMappings.isEmpty) return false;
    return userMappings.any((m) =>
        m.role?.name.toLowerCase() == 'business staff' ||
        m.role?.shortCode.toLowerCase() == 'business_staff');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var mappingsJson = json['user_mappings'] as List?;
    List<UserMapping> mappings = mappingsJson != null
        ? mappingsJson.map((m) => UserMapping.fromJson(m)).toList()
        : [];

    return UserModel(
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: json['status'] as String? ?? '',
      profileImage:
          json['profile_image'] as String? ?? json['profile_pic'] as String?,
      userMappings: mappings,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'status': status,
        'profile_image': profileImage,
        'user_mappings': userMappings.map((m) => m.toJson()).toList(),
      };
}

class UserMapping {
  final String id;
  final String clientId;
  final Role? role;
  final Client? client;

  UserMapping({
    required this.id,
    required this.clientId,
    this.role,
    this.client,
  });

  factory UserMapping.fromJson(Map<String, dynamic> json) {
    return UserMapping(
      id: json['id'] as String? ?? '',
      clientId: json['client_id'] as String? ?? '',
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'client_id': clientId,
        'role': role?.toJson(),
        'client': client?.toJson(),
      };
}

class Role {
  final String id;
  final String name;
  final String shortCode;

  Role({required this.id, required this.name, required this.shortCode});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortCode: json['short_code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'short_code': shortCode,
      };
}

class Client {
  final String id;
  final List<OrgnDetail> orgnDetails;

  Client({required this.id, this.orgnDetails = const []});

  factory Client.fromJson(Map<String, dynamic> json) {
    var detailsJson = json['orgn_details'] as List?;
    return Client(
      id: json['id'] as String? ?? '',
      orgnDetails: detailsJson != null
          ? detailsJson.map((d) => OrgnDetail.fromJson(d)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orgn_details': orgnDetails.map((d) => d.toJson()).toList(),
      };
}

class OrgnDetail {
  final String orgnName;
  final String? logo;

  OrgnDetail({required this.orgnName, this.logo});

  factory OrgnDetail.fromJson(Map<String, dynamic> json) {
    return OrgnDetail(
      orgnName: json['orgn_name'] as String? ?? '',
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'orgn_name': orgnName,
        'logo': logo,
      };
}

/// Full auth response from the API
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
