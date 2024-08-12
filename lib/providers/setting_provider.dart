import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  // Example of a setting toggle
  bool _isEnglishSelected = true;

  bool get isEnglishSelected => _isEnglishSelected;

  void toggleLanguage() {
    _isEnglishSelected = !_isEnglishSelected;
    notifyListeners();
  }

// Add any additional logic needed for the settings screen
}
