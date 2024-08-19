import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ollapp/Sub_Screens/assingment_screen.dart';
import 'package:provider/provider.dart';

import '../Sub_Screens/create_assignment_screen.dart';
import '../Sub_Screens/class_screen.dart';
import '../providers/teacher_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';


class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: Column(
        children: [
          // Top Section
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFF044B89),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 240,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white.withOpacity(0.15)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                right: 220,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white.withOpacity(0.15)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 290,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,

                  ),
                ),
              ),

              Positioned(
                top: 90,
                left: 60,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: NetworkImage(teacherProvider.avatarUrl),
                    ),
                    SizedBox(width: 10),
                    Text(
                      teacherProvider.teacherName,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Scrollable Content Section
          SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Class Teacher Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class Teacher',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ClassCard(
                              title: '9 - A Science',
                              subtitle: 'Islamabad',
                              color: Colors.blueAccent,
                              height: 60.0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ClassSheet()),
                                );
                              },
                            ),
                            ClassCard(
                              title: '8 - A Medical',
                              subtitle: 'Rawalpindi',
                              color: Colors.redAccent,
                              height: 60.0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ClassSheet()),
                                );
                              },
                            ),
                            ClassCard(
                              title: '10 - A Arts',
                              subtitle: 'Lahore',
                              color: Colors.teal,
                              height: 60.0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ClassSheet()),
                                );
                              },
                            ),
                            // Add more cards with their respective bottom sheets
                          ],
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Information Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Information',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        CapsuleListItem(
                          icon: Padding(
                            padding: EdgeInsets.all(1),
                            child: SvgPicture.asset(
                              'assets/images/assignment_icon.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          title: 'Assignments',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AssignmentScreen()),
                            );

                          },
                        ),
                        CapsuleListItem(
                          icon: Padding(
                            padding: EdgeInsets.all(1),
                            child: SvgPicture.asset(
                              'assets/images/announcment_icon.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          title: 'Announcements',
                          onTap: () {},
                        ),
                        CapsuleListItem(
                          icon: Padding(
                            padding: EdgeInsets.all(1),
                            child: SvgPicture.asset(
                              'assets/images/lesson.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          title: 'Lessons',
                          onTap: () {},
                        ),
                        CapsuleListItem(
                          icon: Padding(
                            padding: EdgeInsets.all(1),
                            child: SvgPicture.asset(
                              'assets/images/topics.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          title: 'Topics',
                          onTap: () {},
                        ),
                        CapsuleListItem(
                          icon: Padding(
                            padding: EdgeInsets.all(1),
                            child: SvgPicture.asset(
                              'assets/images/holiday_icon.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          title: 'Holidays',
                          onTap: () {},
                        ),
                        CapsuleListItem(
                          icon: Padding(
                            padding: EdgeInsets.all(1),
                            child: SvgPicture.asset(
                              'assets/images/exam_icon.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          title: 'Exams',
                          onTap: () {},
                        ),
                        CapsuleListItem(
                          icon: SvgPicture.asset(
                            'assets/images/result_icon.svg',
                            width: 44,
                            height: 44,
                          ),
                          title: 'Add Results',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final double height;
  final VoidCallback onTap; // Added callback

  const ClassCard(
      {Key? key,
        required this.title,
        required this.subtitle,
        required this.color,
        required this.onTap, // Added this line
        this.height = 80.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Circle with arrow at the bottom center
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                radius: 16,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: color,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
        ),
    );
  }
}

class CapsuleListItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  const CapsuleListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 80,
          width: 400,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Center horizontally
            children: [
              icon, // Icon
              const SizedBox(width: 1), // Add some space
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 1), // Add some space
              const CircleAvatar(
                backgroundColor: Colors.black,
                radius: 16,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

