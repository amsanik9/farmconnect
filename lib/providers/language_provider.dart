import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'en'; // Default to English

  String get selectedLanguage => _selectedLanguage;

  Locale get locale => Locale(_selectedLanguage);

  void setLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }
}
