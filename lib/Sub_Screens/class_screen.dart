import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ollapp/Navbar.dart';
import 'package:ollapp/UI/TeacherScreen.dart';
import 'package:provider/provider.dart';
import '../models/Student_model.dart';
import '../providers/class_sub_screen_provider.dart';
import 'attendance_screen.dart';

class ClassSheet extends StatefulWidget {
  const ClassSheet({super.key});

  @override
  _ClassSheetState createState() => _ClassSheetState();
}
class _ClassSheetState extends State<ClassSheet> {
  bool _showSearchField = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final subScreenProvider = Provider.of<Sub_screen_Provider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF044B89),

        title: Text(
          'Class 10 - A (Islamabad)',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),

        centerTitle: true,

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
                  subScreenProvider.searchStudents(value);
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

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 10), // Fixed padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildToggleButton(
                    context,
                    "Students",
                    context.watch<Sub_screen_Provider>().isStudentSelected,
                    'student'),
                _buildToggleButton(
                    context,
                    "Subjects",
                    !context.watch<Sub_screen_Provider>().isStudentSelected,
                    'subject'),
              ],
            ),
          ),
        ),

        toolbarHeight: 110, // Custom app bar height
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: subScreenProvider.isStudentSelected
            ? _buildStudentsList(subScreenProvider.students)
            : _buildSubjectsList(subScreenProvider.subjects),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF044B89),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AttendanceScreen()),
          );
        },
        child: SvgPicture.asset(
          'assets/images/take_attendance.svg',
          width: 32,
          height: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildToggleButton(
      BuildContext context, String text, bool isSelected, String tab) {
    return GestureDetector(
      onTap: () {
        context.read<Sub_screen_Provider>().toggleSelection(tab);
      },
      child: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF044B89),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF044B89),
                  ),
                ),
              ),
            )
          : Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildStudentsList(List<Student> students) {
    if (students.isEmpty) {
      return Center(
        child: SvgPicture.asset('assets/images/SWR.svg'),
      );
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        return _buildStudentItem(
            student.profileUrl, student.name, student.rollNo);
      },
    );
  }

  Widget _buildStudentItem(String imagePath, String name, String rollNo) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),

        side: BorderSide(
            color: Colors.grey.withOpacity(0.2), width: 1), // Add a grey border
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imagePath),
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          rollNo,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildSubjectsList(List<Subject> subjects) {
    if (subjects.isEmpty) {
      return Center(
        child: SvgPicture.asset('assets/images/SWR.svg'),
      );
    }

    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];

        return _buildSubjectItem(Icons.web_stories_outlined, subject.name, subject.className);
      },
    );
  }

  Widget _buildSubjectItem(
      IconData icon, String subjectName, String className) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),

        side: BorderSide(
            color: Colors.grey.withOpacity(0.2), width: 1), // Add a grey border
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF044B89), // Blue color

            borderRadius: BorderRadius.circular(10), // Curved edges
          ),

          padding: const EdgeInsets.all(5), // Add some padding

          child: Icon(
            icon,
            size: 30, // Adjust the size as needed
            color: Colors.white, // Icon color
          ),
        ),
        title: Text(
          subjectName,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          className,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
