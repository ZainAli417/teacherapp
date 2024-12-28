import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Student_model.dart';

class Sub_screen_Provider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isStudentSelected = true;
  List<Student> _students = [];
  List<Subject> _subjects = [];
  List<Student> _filteredStudents = []; // New filteredStudents list
  List<Student> get filteredStudents => _filteredStudents;

  bool get isStudentSelected => _isStudentSelected;
  List<Student> get students => _students;
  List<Subject> get subjects => _subjects;

  void toggleSelection(String tab) {
    _isStudentSelected = tab == 'student';
    notifyListeners();
    fetchData();
  }


  void searchStudents(String query) {
    if (query.isEmpty) {
      // If query is empty, show all students
      _filteredStudents = List.from(_students);
    } else {
      // Filter students based on name or rollNo
      _filteredStudents = _students.where((student) =>
      student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.rollNo.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchData() async {
    String currentUserId = _auth.currentUser!.uid;

    if (_isStudentSelected) {
      final QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('teacherId', isEqualTo: currentUserId)
          .get();
      _students = snapshot.docs.map((doc) => Student.fromDocument(doc)).toList();
    } else {
      final QuerySnapshot snapshot = await _firestore
          .collection('subjects')
          .where('teacherId', isEqualTo: currentUserId)
          .get();
      _subjects = snapshot.docs.map((doc) => Subject.fromDocument(doc)).toList();
    }
    notifyListeners();
  }
}