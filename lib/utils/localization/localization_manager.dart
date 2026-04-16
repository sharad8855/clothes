import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();
  factory LocalizationManager() => _instance;
  LocalizationManager._internal();

  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';
  static const String _languageSelectionDoneKey = 'language_selection_done';
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const List<Locale> supportedLocales = [
    Locale('mr', 'IN'), 
    Locale('en', 'US'), 
    Locale('hi', 'IN'), 
  ];

  static const Locale defaultLocale = Locale('en', 'US');

  Locale _currentLocale = defaultLocale;
  Locale get currentLocale => _currentLocale;

  /// Notifies listeners when locale changes. MyApp rebuilds on this.
  final ValueNotifier<Locale> localeNotifier = ValueNotifier(defaultLocale);

  Future<void> initialize() async {
    try {
      final savedLanguage = await _storage.read(key: _languageKey);
      
      if (savedLanguage != null) {
        final matchingLocale = supportedLocales.firstWhere(
          (locale) => locale.languageCode == savedLanguage,
          orElse: () => defaultLocale,
        );
        _currentLocale = matchingLocale;
      } else {
        _currentLocale = defaultLocale;
      }
      localeNotifier.value = _currentLocale;
    } catch (e) {
      debugPrint('Error initializing LocalizationManager: $e');
      _currentLocale = defaultLocale;
      localeNotifier.value = _currentLocale;
    }
  }

  Future<bool> hasCompletedLanguageSelection() async {
    try {
      final done = await _storage.read(key: _languageSelectionDoneKey);
      return done == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> markLanguageSelectionCompleted() async {
    try {
      await _storage.write(key: _languageSelectionDoneKey, value: 'true');
    } catch (e) {
      debugPrint('Error marking language selection done: $e');
    }
  }

  Future<void> changeLocale(Locale locale) async {
    try {
      if (isLocaleSupported(locale)) {
        _currentLocale = locale;
        await _storage.write(key: _languageKey, value: locale.languageCode);
        if (locale.countryCode != null) {
          await _storage.write(key: _countryKey, value: locale.countryCode!);
        }
        localeNotifier.value = locale;
      }
    } catch (e) {
      debugPrint('Error changing locale: $e');
    }
  }

  Locale? getLocaleByLanguageCode(String languageCode) {
    try {
      return supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  bool isLocaleSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  String getCurrentLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'mr':
        return 'मराठी';
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      default:
        return 'English';
    }
  }

  List<Map<String, String>> getAvailableLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
      {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
    ];
  }

  List<String> getSupportedLanguageCodes() {
    return supportedLocales.map((locale) => locale.languageCode).toList();
  }
}
