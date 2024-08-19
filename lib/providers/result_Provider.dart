import 'package:flutter/material.dart';

class resultProvider extends ChangeNotifier {
  String selectedClass = "9-A Science (Islamabad)";
  String selectedSubject = "Arts";
  String selectedYear = "Mid Year";


  void setSelectedClass(String value) {
    selectedClass = value;
    notifyListeners();
  }void setSelectedYear(String value) {
    selectedYear = value;
    notifyListeners();
  }

  void setSelectedSubject(String value) {
    selectedSubject = value;
    notifyListeners();
  }



}
