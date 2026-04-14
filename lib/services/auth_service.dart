import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/session_manager.dart';
import '../models/user_model.dart';
import '../models/order_statistics_model.dart';
import '../models/financial_summary_model.dart';
import '../models/order_list_response.dart';
import '../models/product_model.dart';
import '../models/business_staff_response.dart';
import '../models/order_timeline_response.dart';

/// Handles all HTTP communication with the Bespoke Atelier backend.
class AuthService {
  static const String _baseUrl =
      'https://platform-development-dev.157.20.214.214.nip.io';

  /// Hardcoded Client ID for backend API integrations
  static const String clientId = 'c00c143d-71c3-42d9-b1bd-45f2f6f1297c';

  /// Generates the standard headers needed for authenticated requests
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await SessionManager.instance.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'client-id': clientId,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ─── Password Login ────────────────────────────────────────────────────────
  static Future<AuthResponse> loginWithPassword({
    required String phone,
    required String password,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/auth/verify-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'client-id': clientId,
            },
            body: jsonEncode({
              'phone': cleanPhone,
              'password': password,
              'captchaToken': null,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(body);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Login failed (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Request Reset OTP ─────────────────────────────────────────────────────
  static Future<bool> requestPasswordResetOtp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/auth/request-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'client-id': clientId,
            },
            body: jsonEncode({'phone': cleanPhone}),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to send OTP (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Verify Reset OTP ──────────────────────────────────────────────────────
  static Future<String> verifyPasswordResetOtp({
    required String phone,
    required String otp,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/auth/verify-password-reset-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'client-id': clientId,
            },
            body: jsonEncode({'phone': cleanPhone, 'otp': otp}),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = body['reset_token'] as String?;
        if (token != null && token.isNotEmpty) return token;
        throw const AuthException('Missing reset token in response');
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Invalid OTP (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Reset Password ────────────────────────────────────────────────────────
  static Future<bool> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/auth/reset-password'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'client-id': clientId,
            },
            body: jsonEncode({
              'token': token,
              'new_password': newPassword,
              'confirm_password': confirmPassword,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body['success'] == true;
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Password reset failed (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Invite Staff ──────────────────────────────────────────────────────────
  static Future<bool> inviteStaff({
    required String name,
    required String phone,
    required String email,
    required String jobTitle,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/auth/api/business/client/$clientId/business/257c88b2-8cff-482a-b297-51a9910a3413/invite-staff',
            ),
            headers: headers,
            body: jsonEncode({
              'name': name,
              'phone': cleanPhone,
              'email': email,
              'job_title': jobTitle,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to invite staff (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Order Statistics ──────────────────────────────────────────────────────
  static Future<OrderStatistics> getOrderStatistics() async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/auth/api/order/client/$clientId/order/statistics',
            ),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = body['data'] as Map<String, dynamic>;
        return OrderStatistics.fromJson(data);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to retrieve statistics (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Financial Summary (KPI Reporting) ─────────────────────────────────────
  static Future<FinancialSummary> getFinancialSummary() async {
    try {
      final headers = await getAuthHeaders();
      final now = DateTime.now();
      final startDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-01";
      final endDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final response = await http
          .get(
            Uri.parse(
              'https://reporting.baapmarket.in/api/ecommerce/kpi-dealer-summary?client_id=$clientId&start_date=$startDate&end_date=$endDate',
            ),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FinancialSummary.fromJson(body);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to retrieve financial summary (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Create Customer ────────────────────────────────────────────────────────
  static Future<bool> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    String countryCode = '+91',
  }) async {
    final nameParts = fullName.trim().split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '.';
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/order/client/$clientId/customer'),
            headers: headers,
            body: jsonEncode({
              'client_id': clientId,
              'first_name': firstName,
              'last_name': lastName,
              'email': email,
              'phone_number': cleanPhone,
              'country_code': countryCode,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body['success'] == true;
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to create customer (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Get All Customers ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getAllCustomers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/auth/api/order/client/$clientId/get-all/customer',
            ),
            headers: headers,
            body: jsonEncode({'page': page, 'limit': limit}),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to retrieve customers (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Get All Orders List ──────────────────────────────────────────────────
  static Future<OrderListResponse> getOrdersList({
    int page = 1,
    int limit = 10,
    String? userId,
  }) async {
    final bodyData = {
      'page': page,
      'limit': limit,
      if (userId != null) 'assign_to': userId,
    };

    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/order/client/$clientId/orders/list'),
            headers: headers,
            body: json.encode(bodyData),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderListResponse.fromJson(body);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to retrieve orders (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── User Profile ──────────────────────────────────────────────────────────
  static Future<UserModel> getUserProfile(String userId) async {
    try {
      final headers = await getAuthHeaders();
      // Using the exact URL structure provided for business-specific user profiles
      final response = await http
          .get(
            Uri.parse('$_baseUrl/auth/api/users/client/$clientId/user/$userId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The API returns the profile inside a 'user' field
        return UserModel.fromJson(body['user'] as Map<String, dynamic>);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to retrieve profile (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Upload Profile Image ─────────────────────────────────────────────────
  static Future<String> uploadProfileImage(
    String userId,
    String filePath,
  ) async {
    try {
      final headers = await getAuthHeaders();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/auth/api/public/user/$userId/upload'),
      );

      request.headers.addAll({'Accept': 'application/json', ...headers});

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // usually it returns the url or the updated user object.
        // let's try to parse the body to find a url, or just return success
        try {
          final body = _processResponse(response) as Map<String, dynamic>;
          // Assuming the api returns a url in 'url', 'image_url', 'profile_image', etc.
          final url = body['url'] ?? body['profile_image'] ?? '';
          return url.toString();
        } catch (_) {
          return 'success';
        }
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to upload image (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Get Products ──────────────────────────────────────────────────────────
  static Future<ProductListResponse> getProducts({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/auth/api/product/client/$clientId/get-products',
            ),
            headers: headers,
            body: jsonEncode({'page': page, 'limit': limit}),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductListResponse.fromJson(body);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to fetch products (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Save Customer Measurements ──────────────────────────────────────────
  static Future<Map<String, dynamic>> saveCustomerMeasurements({
    required String customerId,
    required Map<String, dynamic> measurements,
  }) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/auth/api/customer-measurements/client/$clientId/customer/$customerId',
            ),
            headers: headers,
            body: jsonEncode(measurements),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to save measurements (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Get Business Staff ────────────────────────────────────────────────────
  static Future<BusinessStaffResponse> getBusinessStaff({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/auth/api/business/client/$clientId/business/257c88b2-8cff-482a-b297-51a9910a3413/staff',
            ),
            headers: headers,
            body: jsonEncode({'page': page, 'limit': limit}),
          )
          .timeout(const Duration(seconds: 30));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BusinessStaffResponse.fromJson(body);
      }

      final message =
          body['message'] as String? ??
          body['error'] as String? ??
          'Failed to fetch staff (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Create Final Order ────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/api/order/client/$clientId/order'),
            headers: headers,
            body: jsonEncode(orderData),
          )
          .timeout(const Duration(seconds: 45));

      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      }

      final message = body['message'] as String? ??
          body['error'] as String? ??
          'Order creation failed (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Fetch Order Details ───────────────────────────────────────────────────
  static Future<OrderListItem> getOrderDetails(String orderId) async {
    try {
      final headers = await getAuthHeaders();
      final url = Uri.parse('$_baseUrl/auth/api/order/client/$clientId/order/$orderId');
      
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 30));
      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['success'] == true && body['data'] != null) {
          return OrderListItem.fromJson(body['data']);
        }
      }

      final message = body['message'] as String? ?? body['error'] as String? ?? 'Failed to fetch order details';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Fetch Order Timeline ──────────────────────────────────────────────────
  static Future<List<OrderTimelineItem>> getOrderTimeline(String orderId) async {
    try {
      final headers = await getAuthHeaders();
      final url = Uri.parse('$_baseUrl/auth/api/order/client/$clientId/order/$orderId/order-timeline');
      
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 30));
      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body['success'] == true && body['data'] != null) {
          return (body['data'] as List)
              .map((item) => OrderTimelineItem.fromJson(item))
              .toList();
        }
      }

      final message = body['message'] as String? ?? body['error'] as String? ?? 'Failed to fetch order timeline';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Update Order Status ───────────────────────────────────────────────────
  static Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final headers = await getAuthHeaders();
      final url = Uri.parse('$_baseUrl/auth/api/order/client/$clientId/order/$orderId');
      
      final response = await http.put(
        url, 
        headers: headers,
        body: jsonEncode({'order_status': status}),
      ).timeout(const Duration(seconds: 30));
      
      final body = _processResponse(response) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      }

      final message = body['message'] as String? ?? body['error'] as String? ?? 'Failed to update order status';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }

  // ─── Private Helper for Defensive Parsing ──────────────────────────────────
  static dynamic _processResponse(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('❌ JSON Malformed in response: $e');
        print('Raw Body: ${response.body}');
        throw const AuthException('Server returned malformed JSON');
      }
    } else {
      // Log the HTML response for debugging
      print('❌ Non-JSON response received (Status: ${response.statusCode})');
      print('URL: ${response.request?.url}');
      print('Body Snippet: ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}');
      
      throw AuthException(
        'Server returned an invalid response (HTML). Status: ${response.statusCode}. '
        'This often means the URL endpoint is incorrect or the service is down.'
      );
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
