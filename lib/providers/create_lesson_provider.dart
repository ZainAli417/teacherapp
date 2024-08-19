import 'package:flutter/material.dart';

class CreateLessonProvider extends ChangeNotifier {
  String selectedClass = "9-A Science (Islamabad)";
  String selectedSubject = "Arts";
  String assignmentName = "";
  String instructions = "";

  List<String> referenceMaterials = [];

  void setSelectedClass(String value) {
    selectedClass = value;
    notifyListeners();
  }

  void setSelectedSubject(String value) {
    selectedSubject = value;
    notifyListeners();
  }

  void setLessonName(String value) {
    assignmentName = value;
    notifyListeners();
  }

  void setInstructions(String value) {
    instructions = value;
    notifyListeners();
  }
  void addReferenceMaterial(String value) {
    referenceMaterials.add(value);
    notifyListeners();
  }
}
