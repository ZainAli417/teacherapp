import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ollapp/Navbar.dart';

import '../providers/assingment_provider.dart';
import '../providers/create_assignment_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'create_assignment_screen.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final AssignmentProvider assignmentProvider = AssignmentProvider();

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
            "Assignments",
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
                      side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1), // Add a grey border
                    ),
                    child: ListTile(
                      title: Text(
                        'Drawing', // Set your assignment title here
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Due Date: 22-03-2024, 13:29', // Set the date and time here
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
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
            MaterialPageRoute(builder: (context) => const Create_Assingment()),
          );        },
        backgroundColor: const Color(0xFF044B89),
        child: SvgPicture.asset(
          'assets/images/FAB.svg', // Replace with your custom SVG
          width: 40, // Adjust the size as needed
          height: 40, // Adjust the size as needed
          color: Colors.white,
        ),
      ),
    );
  }
}
