import 'dart:math';
import 'package:flutter/material.dart';
import '../core/session_manager.dart';
import '../models/customer_list_response.dart';
import '../models/product_model.dart';
import '../models/business_staff_response.dart';
import '../services/auth_service.dart';

class PackageProvider extends ChangeNotifier {
  // ── Customer Selection ────────────────────────────────────────────────────
  CustomerListItem? _selectedCustomer;
  CustomerListItem? get selectedCustomer => _selectedCustomer;

  void setSelectedCustomer(CustomerListItem customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  // ── Staff Selection (Optional) ──────────────────────────────────────────
  BusinessStaff? _selectedStaff;
  BusinessStaff? get selectedStaff => _selectedStaff;

  void setSelectedStaff(BusinessStaff? staff) {
    _selectedStaff = staff;
    notifyListeners();
  }

  void clearAll() {
    _selectedCustomer = null;
    _selectedProduct = null;
    _selectedStaff = null;
    notifyListeners();
  }

  // ── Product List (from API) ───────────────────────────────────────────────
  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;

  String? _productsError;
  String? get productsError => _productsError;

  Future<void> fetchProducts() async {
    if (_isLoadingProducts) return;
    _isLoadingProducts = true;
    _productsError = null;
    notifyListeners();

    try {
      final response = await AuthService.getProducts(page: 1, limit: 50);
      _products = response.data.where((p) => p.isActive).toList();
    } catch (e) {
      _productsError = e.toString();
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  // ── Product Selection ─────────────────────────────────────────────────────
  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  void setSelectedProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  // ── Computed Price / Summary ──────────────────────────────────────────────
  double get estBasePrice => _selectedProduct?.displayPrice ?? 0;

  String get estPriceFormatted {
    final val = estBasePrice;
    if (val == 0) return '₹0.00';
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '₹${val.toStringAsFixed(2).replaceAllMapped(formatter, (m) => '${m[1]},')}';
  }

  String get selectedProductName => _selectedProduct?.name ?? 'None selected';

  String get selectedCategoryName {
    final cats = _selectedProduct?.productCategory;
    if (cats == null || cats.isEmpty) return '';
    return cats.first.name;
  }

  // ── Final Order Placement ────────────────────────────────────────────────
  bool _isPlacingOrder = false;
  bool get isPlacingOrder => _isPlacingOrder;

  Future<String?> placeOrder({
    required Map<String, dynamic> measurementData,
    required String fabricType,
    required String fabricPattern,
    required List<String> fabricModifiers,
    required String paymentMethod,
    double advanceAmount = 0.0,
  }) async {
    if (_isPlacingOrder) return null;
    _isPlacingOrder = true;
    notifyListeners();

    try {
      final user = await SessionManager.instance.getUser();
      if (user == null || _selectedCustomer == null || _selectedProduct == null) {
        throw Exception("Missing required order data (User, Customer, or Product)");
      }

      // Generate unique IDs for bill and tracking
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(5);
      final random = Random().nextInt(999).toString().padLeft(3, '0');
      final billNumber = "INV$timestamp$random";
      final trackingNumber = "TRK$timestamp$random";
      
      final today = DateTime.now().toIso8601String().split('T')[0];
      final dueDate = DateTime.now().add(const Duration(days: 14)).toIso8601String().split('T')[0];

      final payload = {
        "customer_id": _selectedCustomer!.id,
        "currency": "INR",
        "bill_number": billNumber,
        "order_date": today,
        "quotation_id": null,
        "payment_method": paymentMethod,
        "payment_status": (paymentMethod == 'credit card' || paymentMethod == 'debit card' || paymentMethod == 'upi' || paymentMethod == 'wallet' || advanceAmount > 0) ? 'paid' : 'pending',
        "paid_amount": advanceAmount,
        "gst": 0,
        "shipping_fee": 0,
        "order_status": "pending",
        "tracking_number": trackingNumber,
        "delivery_date": "",
        "due_date": dueDate,
        "price_type": "regular_price",
        "assign_to": _selectedStaff?.userId,
        "customer": {
          "first_name": _selectedCustomer!.firstName ?? '',
          "last_name": _selectedCustomer!.lastName ?? '',
          "phone_number": _selectedCustomer!.phoneNumber,
          "email": _selectedCustomer!.email ?? '',
          "country_code": _selectedCustomer!.countryCode
        },
        "order_items": [
          {
            "product_id": _selectedProduct!.productId,
            "product_variant_id": _selectedProduct!.variants.isNotEmpty 
                ? _selectedProduct!.variants.first.productVariantId 
                : null,
            "quantity": 1,
            "discount_ids": [],
            "gst": 0,
            "discount": 0,
            "discount_type": "percentage"
          }
        ],
        "client_id": AuthService.clientId,
        "user_id": user.id,
        "created_by": user.id,
        "updated_by": user.id,
        // Custom fields for measurements & fabric (serialized into notes for now as per API example)
        "notes": "Fabric: $fabricType, Pattern: $fabricPattern, Modifiers: ${fabricModifiers.join(', ')}"
      };

      final result = await AuthService.createOrder(payload);
      // Return orderId if successful
      if (result['success'] == true && result['data'] != null) {
        return result['data']['order_id']?.toString();
      }
      return null;
    } catch (e) {
      rethrow;
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }
}
