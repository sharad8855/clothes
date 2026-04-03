import 'package:flutter/material.dart';

class FabricProvider extends ChangeNotifier {
  bool _isAnalyzing = false;
  bool get isAnalyzing => _isAnalyzing;

  bool _hasAnalyzed = false;
  bool get hasAnalyzed => _hasAnalyzed;

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
