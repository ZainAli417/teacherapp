import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ollapp/Navbar.dart';
import 'package:http/http.dart' as http;
import 'package:ollapp/Sub_Screens/create_announcement.dart';
import 'package:ollapp/Sub_Screens/create_lesson.dart';
import 'dart:convert';

import '../providers/lesson_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final LessonProvider assignmentProvider = LessonProvider();
  int _attachmentCount = 0;

  @override
  void initState() {
    super.initState();
    //_fetchAttachmentCount();
  }

  Future<void> _fetchAttachmentCount() async {
    try {
      final response =
          await http.get(Uri.parse('https://zbmtech.com/attachments'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _attachmentCount = data['attachment_count'];
        });
      } else {
        // Handle error, e.g., show an error message
        print('Error fetching attachment count: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error, e.g., show an error message
      print('Error fetching attachment count: $error');
    }
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => navbar()),
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
            "Lessons",
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
                    borderSide: const BorderSide(width: 1, color: Colors.black),
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
                    borderSide: const BorderSide(width: 1, color: Colors.black),
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
                          color: Colors.black87),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              //LIST VIEW CODE
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1, // Adjust this value to the number of assignments
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1), // Add a grey border
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'Lesson Name',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Drawing (Practical)', // Set your assignment title here
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //  Divider(height: 0, color: Colors.white), // Add a divider between titles
                        ListTile(
                          title: Text(
                            'Lesson description',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Different Leaf Drawing', // Set your assignment title here
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            _attachmentCount > 0
                                ? '$_attachmentCount Attachment(s)'
                                : '0 Attachment(s)',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            _attachmentCount > 0
                                ? '$_attachmentCount Attachment(s)'
                                : '1 Topic',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Create_Lesson()),
          );
        },
        backgroundColor: const Color(0xFF044B89),
        child: SvgPicture.asset(
          'assets/images/FAB.svg', // Replace with your custom SVG
          width: 45, // Adjust the size as needed
          height: 45, // Adjust the size as needed
          color: Colors.white,
        ),
      ),
    );
  }
}
