import 'package:flutter/material.dart';

class AssignmentProvider extends ChangeNotifier {
  String selectedClass = "9-A Science (Islamabad)";
  String selectedSubject = "Arts";
  String assignmentName = "";
  String instructions = "";
  DateTime dueDate = DateTime.now();
  TimeOfDay dueTime = TimeOfDay.now();
  int points = 0;
  List<String> referenceMaterials = [];

  void setSelectedClass(String value) {
    selectedClass = value;
    notifyListeners();
  }

  void setSelectedSubject(String value) {
    selectedSubject = value;
    notifyListeners();
  }

  void setAssignmentName(String value) {
    assignmentName = value;
    notifyListeners();
  }

  void setInstructions(String value) {
    instructions = value;
    notifyListeners();
  }

  void setDueDate(DateTime value) {
    dueDate = value;
    notifyListeners();
  }

  void setDueTime(TimeOfDay value) {
    dueTime = value;
    notifyListeners();
  }

  void setPoints(int value) {
    points = value;
    notifyListeners();
  }

  void addReferenceMaterial(String value) {
    referenceMaterials.add(value);
    notifyListeners();
  }
}
