import 'package:flutter/material.dart';
import 'package_provider.dart';

enum PaymentMethod { card, paypal, bank, payLater }

class PaymentProvider extends ChangeNotifier {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  PaymentMethod _selectedMethod = PaymentMethod.card;
  PaymentMethod get selectedMethod => _selectedMethod;

  final TextEditingController cardholderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cardholderController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void setPaymentMethod(PaymentMethod method) {
    // Prevent selecting PayPal as it's 'Coming Soon' based on design
    if (method == PaymentMethod.paypal) return; 
    
    _selectedMethod = method;
    notifyListeners();
  }

  Future<String?> processPayment({
    required PackageProvider packageProvider,
    required Map<String, dynamic> measurementData,
    required String fabricType,
    required String fabricPattern,
    required List<String> fabricModifiers,
  }) async {
    if (_isProcessing) return null;

    _isProcessing = true;
    notifyListeners();

    try {
      String methodStr;
      switch (_selectedMethod) {
        case PaymentMethod.card:
          methodStr = 'credit card';
          break;
        case PaymentMethod.bank:
          methodStr = 'bank transfer';
          break;
        case PaymentMethod.payLater:
          methodStr = 'cash';
          break;
        default:
          methodStr = 'cash';
      }

      final result = await packageProvider.placeOrder(
        measurementData: measurementData,
        fabricType: fabricType,
        fabricPattern: fabricPattern,
        fabricModifiers: fabricModifiers,
        paymentMethod: methodStr,
      );

      _isProcessing = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      rethrow;
    }
  }
}
