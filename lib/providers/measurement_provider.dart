import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MeasurementProvider extends ChangeNotifier {
  // Upper body controllers
  final TextEditingController chestController = TextEditingController();
  final TextEditingController bustController = TextEditingController(); // NEW
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController sleeveController = TextEditingController();
  final TextEditingController armLengthController = TextEditingController(); // NEW
  final TextEditingController neckController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController heightController = TextEditingController(); // NEW

  // Lower body controllers
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController thighController = TextEditingController(); // NEW
  final TextEditingController kneeController = TextEditingController(); // NEW
  final TextEditingController calfController = TextEditingController(); // NEW
  final TextEditingController ankleController = TextEditingController(); // NEW
  final TextEditingController inseamController = TextEditingController();
  final TextEditingController outseamController = TextEditingController();

  // Notes & Metadata
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customizeDetailsController = TextEditingController();
  final TextEditingController extraOptionsController = TextEditingController();
  
  String _gender = 'male';
  String get gender => _gender;
  set gender(String val) {
    _gender = val;
    notifyListeners();
  }

  String _measurementUnit = 'inch';
  String get measurementUnit => _measurementUnit;
  set measurementUnit(String val) {
    _measurementUnit = val;
    notifyListeners();
  }

  bool _isDefault = true;
  bool get isDefault => _isDefault;
  set isDefault(bool val) {
    _isDefault = val;
    notifyListeners();
  }

  // Dynamic Custom Fields
  final List<Map<String, dynamic>> _customFields = [];
  List<Map<String, dynamic>> get customFields => _customFields;

  void addCustomField() {
    _customFields.add({
      'label': TextEditingController(),
      'value': TextEditingController(),
    });
    notifyListeners();
  }

  void removeCustomField(int index) {
    _customFields[index]['label'].dispose();
    _customFields[index]['value'].dispose();
    _customFields.removeAt(index);
    notifyListeners();
  }

  bool _isExtracting = false;
  bool get isExtracting => _isExtracting;

  @override
  void dispose() {
    chestController.dispose();
    bustController.dispose();
    shoulderController.dispose();
    sleeveController.dispose();
    armLengthController.dispose();
    neckController.dispose();
    lengthController.dispose();
    heightController.dispose();
    waistController.dispose();
    hipController.dispose();
    thighController.dispose();
    kneeController.dispose();
    calfController.dispose();
    ankleController.dispose();
    inseamController.dispose();
    outseamController.dispose();
    notesController.dispose();
    customizeDetailsController.dispose();
    extraOptionsController.dispose();
    for (var field in _customFields) {
      field['label'].dispose();
      field['value'].dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> getMeasurementMap(String customerId) {
    final Map<String, dynamic> data = {
      "customer_id": customerId,
      "client_id": AuthService.clientId,
      "gender": _gender,
      "measurement_unit": _measurementUnit,
      "chest": double.tryParse(chestController.text),
      "bust": double.tryParse(bustController.text),
      "waist": double.tryParse(waistController.text),
      "shoulder": double.tryParse(shoulderController.text),
      "sleeve_length": double.tryParse(sleeveController.text),
      "arm_length": double.tryParse(armLengthController.text),
      "neck": double.tryParse(neckController.text),
      "hip": double.tryParse(hipController.text),
      "thigh": double.tryParse(thighController.text),
      "knee": double.tryParse(kneeController.text),
      "calf": double.tryParse(calfController.text),
      "ankle": double.tryParse(ankleController.text),
      "height": double.tryParse(heightController.text),
      "length": double.tryParse(lengthController.text),
      "inseam": double.tryParse(inseamController.text),
      "outseam": double.tryParse(outseamController.text),
      "extra_options": extraOptionsController.text,
      "notes": notesController.text,
      "is_default": _isDefault,
    };

    if (_customFields.isNotEmpty) {
      String customSummary = "\n\nCustom Measurements:";
      for (var field in _customFields) {
        customSummary += "\n${field['label'].text}: ${field['value'].text}";
      }
      data['notes'] = (data['notes'] ?? "") + customSummary;
    }
    return data;
  }

  Future<void> submitMeasurements(BuildContext context, String customerId) async {
    _setLoading(true);
    try {
      final Map<String, dynamic> data = getMeasurementMap(customerId);

      await AuthService.saveCustomerMeasurements(
        customerId: customerId,
        measurements: data,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Measurements saved successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool val) {
    _isExtracting = val;
    notifyListeners();
  }
}
