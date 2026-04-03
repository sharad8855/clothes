import 'package:flutter/material.dart';

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

  Future<bool> processPayment() async {
    if (_isProcessing) return false;

    _isProcessing = true;
    notifyListeners();

    // Mock an order placement/payment processing backend delay
    await Future.delayed(const Duration(seconds: 3));

    _isProcessing = false;
    notifyListeners();
    
    return true; // Simulate success
  }
}
