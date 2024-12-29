import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ollapp/Navbar.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:ollapp/UI/TeacherScreen.dart';

import '../providers/create_topic_provider.dart';

class Create_lecture extends StatefulWidget {
  const Create_lecture({super.key});

  @override
  State<Create_lecture> createState() => _Create_LectureState();
}

class _Create_LectureState extends State<Create_lecture> {
  final CreateTopicProvider assignmentProvider = CreateTopicProvider();

  List<File> _selectedFiles = [];
  bool _isUploading = false;

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  Future<List<String>> _uploadFilesToFirebase() async {
    List<String> downloadUrls = [];
    final teachername = FirebaseAuth.instance.currentUser?.displayName;

    try {
      for (var file in _selectedFiles) {
        final fileName = file.path.split('/').last;
        final ref = FirebaseStorage.instance
            .ref()
            .child('study_materials/$teachername/$fileName');
        final uploadTask = ref.putFile(file);

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    } catch (e) {
      print("Error uploading files: $e");
    }

    return downloadUrls;
  }

  Future<void> _saveToFirestore(CreateTopicProvider assignmentProvider) async {
    setState(() {
      _isUploading = true;
    });

    final teacherId = FirebaseAuth.instance.currentUser?.uid;
    final audioUrls = await _uploadFilesToFirebase();

    final docRef =
        FirebaseFirestore.instance.collection('Study_material').doc();
    await docRef.set({
      'TopicName': assignmentProvider.assignmentName,
      'ClassSelected': assignmentProvider.selectedClass,
      'SubjectSelected': assignmentProvider.selectedSubject,
      'TopicDescription': assignmentProvider.instructions,
      'TeacherId': teacherId,
      'AudioFiles': audioUrls,
      'CreatedAt': FieldValue.serverTimestamp(),
      'Status': assignmentProvider.status,
    });

    setState(() {
      _isUploading = false;
      _selectedFiles.clear();
    });

    _showSnackbar_connection(context, 'Topic added successfully!');
  }

  void _showSnackbar_connection(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // Set the height
        child: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/back_icon.svg',
              width: 25, // Adjust the size as needed
              height: 25, // Adjust the size as needed
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  TeacherScreen()),
              );
            },
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          title: Text(
            "Upload Lectures",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF044B89),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      value: assignmentProvider.selectedClass,
                      onChanged: (value) {
                        assignmentProvider.setSelectedClass(value!);
                      },
                      items: [
                        "9-A Science (Islamabad)",
                        "9-B Biology (Rawalpindi)",
                        "9-C Arts (Lahore)",
                        "10-A Science (Islamabad)",
                        "10-B Biology (Rawalpindi)",
                        "10-C Arts (Lahore)",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      value: assignmentProvider.selectedSubject,
                      onChanged: (value) {
                        assignmentProvider.setSelectedSubject(value!);
                      },
                      items: [
                        "Arts",
                        "Science",
                        "Computer",
                        "Bio",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Lecture Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      onChanged: (value) {
                        assignmentProvider.setTopicName(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Lecture Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      maxLines: 5,
                      onChanged: (value) {
                        assignmentProvider.setInstructions(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickFiles,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF044B89),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedFiles.isNotEmpty
                                  ? "${_selectedFiles.length} file(s) selected"
                                  : "Study Material(s)",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 46),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isUploading
                            ? null
                            : () => _saveToFirestore(assignmentProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF044B89),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _isUploading ? "Submitting..." : "Submit For Review",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1E7ED2),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
