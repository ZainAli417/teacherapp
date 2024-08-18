import 'package:flutter/material.dart';

class Sub_screen_Provider with ChangeNotifier {
  bool _isStudentSelected = true;

  bool get isStudentSelected => _isStudentSelected;

  void toggleSelection() {
    _isStudentSelected = !_isStudentSelected;
    notifyListeners();
  }
}