import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Navbar.dart';
import '../providers/attendance_provider.dart';
import 'package:intl/intl.dart'; // For formatting the current date
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'class_screen.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AttendanceProvider>(context);
    var currentDate =
        DateFormat('dd-MM-yyyy').format(DateTime.now()); // Get current date

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF044B89),

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
              MaterialPageRoute(builder: (context) => ClassSheet()),
            );
          },
        ),
        title: Column(
          children: [
            Text(
              'Take Attendance',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  currentDate,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: SizedBox(width: 16),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),

        toolbarHeight: 110, // Custom app bar height
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  var student = provider.students[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1), // Add a grey border
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(student.imageUrl),
                        radius: 24,
                      ),
                      title: Text(student.name),
                      subtitle: Text(student.rollNo),
                      trailing: ElevatedButton(
                        onPressed: () {
                          provider.toggleAttendance(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: student.isPresent
                              ? const Color(0xFF044B89)
                              : const Color(0xFF044B89),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Present',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.submitAttendance();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF044B89),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal:
                        60), // Reduced vertical padding and added horizontal padding
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
