import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String id;
  String name;
  String rollNo;
  String profileUrl;
  String teacherId;
  String attendence;

  Student({required this.id, required this.name, required this.rollNo, required this.profileUrl, required this.teacherId,required this.attendence});

  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student(
      id: doc.id,
      name: doc['name'],
      rollNo: doc['rollNo'],
      profileUrl: doc['profileUrl'],
      teacherId: doc['teacherId'],
      attendence: doc['attendance'],
    );
  }
}
