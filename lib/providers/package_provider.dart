import 'package:flutter/material.dart';

enum GarmentType { suit, tuxedo, overcoat, shirt }
enum LapelType { notch, peak, shawl }
enum VentStyle { single, double, none }
enum ButtonCount { one, two, three, doubleBreasted }

class PackageProvider extends ChangeNotifier {
  GarmentType _selectedGarment = GarmentType.suit;
  GarmentType get selectedGarment => _selectedGarment;

  LapelType _selectedLapel = LapelType.notch;
  LapelType get selectedLapel => _selectedLapel;

  VentStyle _selectedVent = VentStyle.double;
  VentStyle get selectedVent => _selectedVent;

  ButtonCount _selectedButton = ButtonCount.two;
  ButtonCount get selectedButton => _selectedButton;

  bool _isSmartSuggestApplied = false;
  bool get isSmartSuggestApplied => _isSmartSuggestApplied;

  // Smart suggest package info
  final String suggestPackageName = "Savile Slim Fit Package";
  final double craftsmanshipMarkup = 450.0;
  final String craftsmanshipName = "Full Canvas";

  void setGarmentType(GarmentType type) {
    _selectedGarment = type;
    if (_isSmartSuggestApplied) _isSmartSuggestApplied = false;
    notifyListeners();
  }

  void setLapelType(LapelType type) {
    _selectedLapel = type;
    notifyListeners();
  }

  void setVentStyle(VentStyle style) {
    _selectedVent = style;
    notifyListeners();
  }

  void setButtonCount(ButtonCount count) {
    _selectedButton = count;
    notifyListeners();
  }

  void applySmartSuggest() {
    _isSmartSuggestApplied = true;
    _selectedGarment = GarmentType.suit;
    _selectedLapel = LapelType.notch;
    _selectedVent = VentStyle.double;
    _selectedButton = ButtonCount.two;
    notifyListeners();
  }

  double get estBasePrice {
    double base = 0;
    switch (_selectedGarment) {
      case GarmentType.suit:
        base = 1445.00; 
        break;
      case GarmentType.tuxedo:
        base = 1800.00;
        break;
      case GarmentType.overcoat:
        base = 1650.00;
        break;
      case GarmentType.shirt:
        base = 350.00;
        break;
    }
    
    // Always adding craftsmanship logic as per the mock for Two-Piece suit
    if (_selectedGarment == GarmentType.suit) {
       base += craftsmanshipMarkup;
    }
    
    return base; 
  }

  String get garmentName {
    switch (_selectedGarment) {
      case GarmentType.suit: return "Two-Piece Suit";
      case GarmentType.tuxedo: return "Tuxedo";
      case GarmentType.overcoat: return "Overcoat";
      case GarmentType.shirt: return "Bespoke Shirt";
    }
  }

  String get lapelName {
    switch (_selectedLapel) {
      case LapelType.notch: return "Notch Lapel (Default)";
      case LapelType.peak: return "Peak Lapel";
      case LapelType.shawl: return "Shawl Lapel";
    }
  }

  String get ventName {
    switch (_selectedVent) {
      case VentStyle.double: return "Double Side Vents";
      case VentStyle.single: return "Single Center Vent";
      case VentStyle.none: return "No Vents";
    }
  }

  String get buttonName {
    switch (_selectedButton) {
      case ButtonCount.one: return "1 Button Single Breasted";
      case ButtonCount.two: return "2 Button Single Breasted";
      case ButtonCount.three: return "3 Button Single Breasted";
      case ButtonCount.doubleBreasted: return "Double Breasted";
    }
  }

  String get estPriceFormatted {
    final val = estBasePrice;
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return '\$${val.toStringAsFixed(2).replaceAllMapped(formatter, (m) => '${m[1]},')}';
  }
}
