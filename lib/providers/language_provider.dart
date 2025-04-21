import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'en'; // Default to English

  String get selectedLanguage => _selectedLanguage;

  void setLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }
}
