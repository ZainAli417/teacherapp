import 'package:flutter/material.dart';

class LessonProvider extends ChangeNotifier {
  String selectedClass = "9-A Science (Islamabad)";
  String selectedSubject = "Arts";


  void setSelectedClass(String value) {
    selectedClass = value;
    notifyListeners();
  }

  void setSelectedSubject(String value) {
    selectedSubject = value;
    notifyListeners();
  }
}
