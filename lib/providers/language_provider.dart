import 'package:flutter/material.dart';
import '../utils/localization/localization_manager.dart';

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final Locale locale;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.locale,
  });
}

class LanguageProvider extends ChangeNotifier {
  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      locale: Locale('en'),
    ),
    LanguageOption(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      locale: Locale('hi'),
    ),
    LanguageOption(
      code: 'mr',
      name: 'Marathi',
      nativeName: 'मराठी',
      locale: Locale('mr'),
    ),
  ];

  LanguageOption _selectedLanguage = supportedLanguages[0]; // Default: English

  LanguageOption get selectedLanguage => _selectedLanguage;
  Locale get currentLocale => _selectedLanguage.locale;
  String get currentLanguageCode => _selectedLanguage.code;

  void setLanguage(String code) {
    final lang = supportedLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => supportedLanguages[0],
    );
    if (_selectedLanguage.code != lang.code) {
      _selectedLanguage = lang;
      // Update the global locale for the app
      LocalizationManager().changeLocale(lang.locale);
      notifyListeners();
    }
  }
}
