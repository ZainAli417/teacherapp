import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/attendance_provider.dart';
import 'class_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For fetching current user's UID

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<void> _fetchStudentsFuture;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchField = false;

  @override
  void initState() {
    super.initState();
    final String teacherId = FirebaseAuth.instance.currentUser!.uid;
    _fetchStudentsFuture =
        Provider.of<AttendanceProvider>(context, listen: false)
            .fetchStudents(teacherId);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AttendanceProvider>(context);
    var currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF044B89),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/back_icon.svg',
            width: 25,
            height: 25,
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
        flexibleSpace: const SizedBox(width: 16),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showSearchField = !_showSearchField;
              });
            },
          ),
          if (_showSearchField)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _showSearchField ? 150 : 0,
              child: TextField(
                style: GoogleFonts.poppins(
                  color: Colors.white,
                    fontSize: 12, fontWeight: FontWeight.w500),
                controller: _searchController,
                onChanged: (value) {
                  provider.searchStudents(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search Student',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    // Set text color to white
                    fontWeight: FontWeight.w500
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        toolbarHeight: 110,
      ),
      body: FutureBuilder(
        future: _fetchStudentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ));
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                  "Failed to load students",
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ));
          }

          if (provider.students.isEmpty) {
            return Center(
                child: Text(
                  "No students found.",
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Note: Press to Toggle The Attendance Status',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w500,color: Colors.red[700]),
                ),
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
                              color: Colors.grey.withOpacity(0.2), width: 1),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(student.profileUrl),
                            radius: 24,
                          ),
                          title: Text(student.name),
                          subtitle: Text(student.rollNo),
                          trailing: ElevatedButton(
                            onPressed: () {
                              provider.toggleAttendance(
                                  provider.students.indexOf(student)); // Get the index of the student in the original list
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: student.attendence == 'present'
                                  ? const Color(0xFF3EAF00)
                                  : const Color(0xFFD60A21),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              student.attendence == 'present'
                                  ? 'Present'
                                  : 'Absent',
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
                    provider.submitAttendance(context); // Pass the context here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044B89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 60),
                  ),
                  child: Text(
                    'Submit Attendance',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          );
        },
      ),
    );
  }
}