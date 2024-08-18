import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ollapp/Navbar.dart';

import '../providers/create_assignment_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Create_Assingment extends StatefulWidget {
  const Create_Assingment({super.key});

  @override
  State<Create_Assingment> createState() => _Create_AssingmentState();
}

class _Create_AssingmentState extends State<Create_Assingment> {
  final CreateAssingmentProvider assignmentProvider = CreateAssingmentProvider();

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
            "Create Assignment",
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
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Assignment Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  assignmentProvider.setAssignmentName(value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Instructions",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                maxLines: 5,
                onChanged: (value) {
                  assignmentProvider.setInstructions(value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Due Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: assignmentProvider.dueDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          assignmentProvider.setDueDate(pickedDate);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Due Time",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: assignmentProvider.dueTime,
                        );
                        if (pickedTime != null) {
                          assignmentProvider.setDueTime(pickedTime);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Points",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  assignmentProvider.setPoints(int.tryParse(value) ?? 0);
                },
              ),
              const SizedBox(height: 20),
              Container(
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
                        color: Color(0xFF044B89), // You can change the color as per your requirement
                      ),
                      child: const Icon(Icons.add, color: Colors.white,),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Reference Materials",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 46),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Create Assignment
                  },
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
                    "Create Assignment",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
