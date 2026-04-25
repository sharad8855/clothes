import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FabricProvider extends ChangeNotifier {
  bool _isAnalyzing = false;
  bool get isAnalyzing => _isAnalyzing;

  bool _hasAnalyzed = false;
  bool get hasAnalyzed => _hasAnalyzed;

  // Selected image file
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  // AI Analyzed Fields
  String _material = '--';
  String get material => _material;

  String _weight = '--';
  String get weight => _weight;

  String _colorPalette = '--';
  String get colorPalette => _colorPalette;

  String _pattern = '--';
  String get pattern => _pattern;

  // Manual Overrides
  String _selectedFabricType = 'Premium Merino Wool';
  String get selectedFabricType => _selectedFabricType;

  String _selectedPrimaryPattern = 'Micro-Pinstripe';
  String get selectedPrimaryPattern => _selectedPrimaryPattern;

  // Modifier Tags Multi-Select
  final Set<String> _selectedModifiers = {'High Shine'};
  Set<String> get selectedModifiers => _selectedModifiers;

  final ImagePicker _picker = ImagePicker();

  /// Camera उघडतो आणि photo घेतो
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        _selectedImage = File(photo.path);
        notifyListeners();
        await startAnalysis();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  /// Gallery उघडतो आणि image pick करतो
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
        await startAnalysis();
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
    }
  }

  Future<void> startAnalysis() async {
    if (_isAnalyzing) return;

    _isAnalyzing = true;
    notifyListeners();

    // Mock processing delay simulating image texture read
    await Future.delayed(const Duration(seconds: 2));

    _material = 'Wool Blend';
    _weight = 'Medium (280g)';
    _colorPalette = 'Navy / Indigo';
    _pattern = 'Subtle Pinstripe';

    _hasAnalyzed = true;
    _isAnalyzing = false;
    notifyListeners();
  }

  void setFabricType(String? value) {
    if (value != null) {
      _selectedFabricType = value;
      notifyListeners();
    }
  }

  void setPrimaryPattern(String? value) {
    if (value != null) {
      _selectedPrimaryPattern = value;
      notifyListeners();
    }
  }

  void toggleModifier(String modifier) {
    if (_selectedModifiers.contains(modifier)) {
      _selectedModifiers.remove(modifier);
    } else {
      _selectedModifiers.add(modifier);
    }
    notifyListeners();
  }
}
