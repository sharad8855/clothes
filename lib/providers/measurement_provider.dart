import 'package:flutter/material.dart';

class MeasurementProvider extends ChangeNotifier {
  // Upper body controllers
  final TextEditingController chestController = TextEditingController();
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController sleeveController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();

  // Lower body controllers
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController inseamController = TextEditingController();
  final TextEditingController outseamController = TextEditingController();

  // Notes controller
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customizeDetailsController = TextEditingController();

  bool _isExtracting = false;
  bool get isExtracting => _isExtracting;

  @override
  void dispose() {
    chestController.dispose();
    shoulderController.dispose();
    sleeveController.dispose();
    neckController.dispose();
    lengthController.dispose();
    waistController.dispose();
    hipController.dispose();
    inseamController.dispose();
    outseamController.dispose();
    notesController.dispose();
    customizeDetailsController.dispose();
    super.dispose();
  }

  Future<void> startAIExtraction() async {
    if (_isExtracting) return;
    
    _isExtracting = true;
    notifyListeners();

    // Mock an AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Auto-fill metric fields 
    chestController.text = "42.5";
    shoulderController.text = "18.0";
    sleeveController.text = "25.0";
    neckController.text = "16.5";
    lengthController.text = "30.0";
    
    waistController.text = "34.0";
    hipController.text = "40.0";
    inseamController.text = "32.0";
    outseamController.text = "42.5";
    
    notesController.text = "Prefer tighter fit around waist, extra allowance for cuffing.";
    customizeDetailsController.text = "Monogram on left cuff, gold threading on button holes.";

    _isExtracting = false;
    notifyListeners();
  }
}
