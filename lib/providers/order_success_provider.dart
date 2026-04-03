import 'package:flutter/material.dart';

enum WhatsAppStatus { idle, sending, sent }

class OrderSuccessProvider extends ChangeNotifier {
  WhatsAppStatus _whatsAppStatus = WhatsAppStatus.idle;
  WhatsAppStatus get whatsAppStatus => _whatsAppStatus;

  Future<void> sendWhatsAppNotification() async {
    if (_whatsAppStatus != WhatsAppStatus.idle) return;

    _whatsAppStatus = WhatsAppStatus.sending;
    notifyListeners();

    // Mock API call latency for a messaging service
    await Future.delayed(const Duration(seconds: 2));

    _whatsAppStatus = WhatsAppStatus.sent;
    notifyListeners();
  }
}
