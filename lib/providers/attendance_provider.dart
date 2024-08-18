import 'package:flutter/material.dart';

class AttendanceProvider with ChangeNotifier {
  final List<Student> _students = [
    Student(name: 'Zain Ali', rollNo: '20-Arid-557', imageUrl: 'assets/images/panda.jpeg', isPresent: false),
    Student(name: 'Hafsa Malik', rollNo: '20-Arid-468', imageUrl: 'assets/images/panda.jpeg', isPresent: true),
  ];

  List<Student> get students => _students;

  void toggleAttendance(int index) {
    _students[index].isPresent = !_students[index].isPresent;
    notifyListeners();
  }

  void submitAttendance() {
    // Add your logic to submit the attendance
  }
}

class Student {
  String name;
  String rollNo;
  String imageUrl;
  bool isPresent;

  Student({
    required this.name,
    required this.rollNo,
    required this.imageUrl,
    this.isPresent = false,
  });
}
