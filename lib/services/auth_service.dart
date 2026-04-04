import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/session_manager.dart';
import '../models/user_model.dart';
import '../models/order_statistics_model.dart';
import '../models/financial_summary_model.dart';
import '../models/order_list_response.dart';

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

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(body);
      }

      final message = body['message'] as String? ??
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

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; 
      }

      final message = body['message'] as String? ??
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
            body: jsonEncode({
              'phone': cleanPhone,
              'otp': otp,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = body['reset_token'] as String?;
        if (token != null && token.isNotEmpty) return token;
        throw const AuthException('Missing reset token in response');
      }

      final message = body['message'] as String? ??
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

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body['success'] == true;
      }

      final message = body['message'] as String? ??
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
            Uri.parse('$_baseUrl/auth/api/business/client/$clientId/business/3f46574b-0fa7-41b5-ba42-fa2aa75e6800/invite-staff'),
            headers: headers,
            body: jsonEncode({
              'name': name,
              'phone': cleanPhone,
              'email': email,
              'job_title': jobTitle,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; 
      }

      final message = body['message'] as String? ??
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
            Uri.parse('$_baseUrl/auth/api/order/client/$clientId/order/statistics'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = body['data'] as Map<String, dynamic>;
        return OrderStatistics.fromJson(data);
      }

      final message = body['message'] as String? ??
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
      final startDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-01";
      final endDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final response = await http
          .get(
            Uri.parse('https://reporting.baapmarket.in/api/ecommerce/kpi-dealer-summary?client_id=$clientId&start_date=$startDate&end_date=$endDate'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FinancialSummary.fromJson(body);
      }

      final message = body['message'] as String? ??
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
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '.';
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

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body['success'] == true;
      }

      final message = body['message'] as String? ??
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
            Uri.parse('$_baseUrl/auth/api/order/client/$clientId/get-all/customer'),
            headers: headers,
            body: jsonEncode({
              'page': page,
              'limit': limit,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      }

      final message = body['message'] as String? ??
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
  }) async {
    final bodyData = {
      'page': page,
      'limit': limit,
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

      final body = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderListResponse.fromJson(body);
      }

      final message = body['message'] as String? ??
          body['error'] as String? ??
          'Failed to retrieve orders (${response.statusCode})';
      throw AuthException(message);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e');
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
