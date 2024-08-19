import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ollapp/Navbar.dart';
import 'package:ollapp/UI/TeacherScreen.dart';
import 'package:provider/provider.dart';
import '../providers/class_sub_screen_provider.dart';
import 'attendance_screen.dart';

class ClassSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            width: 25,  // Adjust the size as needed
            height: 25, // Adjust the size as needed
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => navbar()),
            );          },
        ),

        actions: const [
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          SizedBox(width: 16),
        ],

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Fixed padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildToggleButton(context, "Students",
                    context.watch<Sub_screen_Provider>().isStudentSelected),
                _buildToggleButton(context, "Subjects",
                    !context.watch<Sub_screen_Provider>().isStudentSelected),
              ],
            ),
          ),
        ),

        toolbarHeight: 110, // Custom app bar height
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: context.watch<Sub_screen_Provider>().isStudentSelected
            ? _buildStudentsList()
            : _buildSubjectsList(),
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
  Widget _buildToggleButton(BuildContext context, String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<Sub_screen_Provider>().toggleSelection();
      },
      child: isSelected
          ? Container(
        padding: const EdgeInsets.symmetric(vertical:5, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF044B89),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical:7),
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


  Widget _buildStudentsList() {
    return ListView(
      children: [
        _buildStudentItem(
          'assets/images/panda.jpeg', // Add your images here
          'Zain Ali',
          '20-Arid-557',
        ),
        _buildStudentItem(
          'assets/images/panda.jpeg',
          'Hafsa Malik',
          '20-Arid-468',
        ),
      ],
    );
  }

  Widget _buildStudentItem(String imagePath, String name, String rollNo) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1), // Add a grey border
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
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

  Widget _buildSubjectsList() {
    return ListView(
      children: [
        _buildSubjectItem(Icons.biotech, 'Biology', 'Class 10 - A'),
        _buildSubjectItem(Icons.computer, 'Computer', 'Class 10 - A'),
        _buildSubjectItem(Icons.brush, 'Arts', 'Class 9 - A'),
        _buildSubjectItem(Icons.science, 'Science', 'Class 8 - A'),
      ],
    );
  }

  Widget _buildSubjectItem(IconData icon, String subjectName, String className)
  {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1), // Add a grey border
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
