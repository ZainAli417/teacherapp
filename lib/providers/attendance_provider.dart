import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/Student_model.dart';

class AttendanceProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Student> _students = [];
  List<Student> get students => _students;
  List<Student> _filteredStudents = []; // New filteredStudents list
  List<Student> get filteredStudents => _filteredStudents;

  bool isLoading = false;

  Future<void> fetchStudents(String teacherId) async {
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('students')
          .where('teacherId', isEqualTo: teacherId)
          .get();

      _students = querySnapshot.docs
          .map((doc) => Student.fromDocument(doc))
          .toList();

      // Initialize filteredStudents with all students on first load
      _filteredStudents = List.from(_students);
    } catch (error) {
      print("Failed to fetch students: $error");
    }

    isLoading = false;
    notifyListeners();
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

  void toggleAttendance(int index) async {
    Student student = _students[index];
    String newAttendanceStatus = student.attendence == 'present' ? 'absent' : 'present';

    try {
      await _firestore.collection('students').doc(student.id).update({
        'attendance': newAttendanceStatus,
      });

      student.attendence = newAttendanceStatus;
      // Update the filteredStudents list as well
      _filteredStudents[_filteredStudents.indexOf(student)] = student;
      notifyListeners();
    } catch (error) {
      print("Failed to update attendance: $error");
    }
  }


  void submitAttendance(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      for (Student student in _students) {
        String newAttendanceStatus =
        student.attendence == 'present' ? 'present' : 'absent';

        await _firestore.collection('students').doc(student.id).update({
          'attendance': newAttendanceStatus,
        });
      }

      // Show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Attendance Updated Successfully',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.green.withOpacity(0.8),
          duration: const Duration(seconds: 5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(8),
        ),
      );
    } catch (error) {
      // Show error Snackbar if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed To Upload attendance',
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(8),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}