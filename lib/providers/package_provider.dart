import 'package:flutter/material.dart';
import '../models/customer_list_response.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';

class PackageProvider extends ChangeNotifier {
  // ── Customer Selection ────────────────────────────────────────────────────
  CustomerListItem? _selectedCustomer;
  CustomerListItem? get selectedCustomer => _selectedCustomer;

  void setSelectedCustomer(CustomerListItem customer) {
    _selectedCustomer = customer;
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
}
