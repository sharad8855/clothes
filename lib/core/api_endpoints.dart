class ApiEndpoints {
  static const String baseUrl = 'https://platform-development-dev.157.20.214.214.nip.io';
  static const String reportingBaseUrl = 'https://reporting.baapmarket.in';

  // Auth & OTP
  static const String verifyOtp = '$baseUrl/auth/api/auth/verify-otp';
  static const String requestOtp = '$baseUrl/auth/api/auth/request-otp';
  static const String verifyPasswordResetOtp = '$baseUrl/auth/api/auth/verify-password-reset-otp';
  static const String resetPassword = '$baseUrl/auth/api/auth/reset-password';

  // Users & Profile
  static String userProfile(String clientId, String userId) => '$baseUrl/auth/api/users/client/$clientId/user/$userId';
  static String userImageUpload(String userId) => '$baseUrl/auth/api/public/user/$userId/upload';

  // Business
  static String createBusiness(String clientId) => '$baseUrl/auth/api/business/client/$clientId/';
  static String getBusinessDetails(String clientId, String businessId) => '$baseUrl/auth/api/business/client/$clientId/business/$businessId';
  static String getAllBusinesses(String clientId) => '$baseUrl/auth/api/business/client/$clientId/get-all';
  static String getBusinessStaff(String clientId, String businessId) => '$baseUrl/auth/api/business/client/$clientId/business/$businessId/staff';
  static String inviteStaff(String clientId, String businessId) => '$baseUrl/auth/api/business/client/$clientId/business/$businessId/invite-staff';

  // Customers
  static String createCustomer(String clientId) => '$baseUrl/auth/api/order/client/$clientId/customer';
  static String getAllCustomers(String clientId) => '$baseUrl/auth/api/order/client/$clientId/get-all/customer';
  static String saveCustomerMeasurements(String clientId, String customerId) => '$baseUrl/auth/api/customer-measurements/client/$clientId/customer/$customerId';

  // Products
  static String getProducts(String clientId) => '$baseUrl/auth/api/product/client/$clientId/get-products';

  // Orders
  static String createOrder(String clientId) => '$baseUrl/auth/api/order/client/$clientId/order';
  static String getOrdersList(String clientId) => '$baseUrl/auth/api/order/client/$clientId/orders/list';
  static String getOrderDetails(String clientId, String orderId) => '$baseUrl/auth/api/order/client/$clientId/order/$orderId';
  static String getOrderTimeline(String clientId, String orderId) => '$baseUrl/auth/api/order/client/$clientId/order/$orderId/order-timeline';
  static String updateOrderStatus(String clientId, String orderId) => '$baseUrl/auth/api/order/client/$clientId/order/$orderId';
  static String getOrderStatistics(String clientId) => '$baseUrl/auth/api/order/client/$clientId/order/statistics';

  // Reporting / KPI
  static String getFinancialSummary() => '$reportingBaseUrl/api/ecommerce/kpi-dealer-summary';
}
