import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ollapp/Sub_Screens/assingment_screen.dart';
import 'package:ollapp/UI/TeacherScreen.dart';
import 'package:provider/provider.dart';
import '../Sub_Screens/announcement_screen.dart';
import '../Sub_Screens/class_screen.dart';
import '../Sub_Screens/exams.dart';
import '../Sub_Screens/holiday_screen.dart';
import '../Sub_Screens/lesson_screen.dart';
import '../Sub_Screens/results.dart';
import '../models/audioplayer.dart';
import '../providers/principal_provider.dart';
import '../providers/teacher_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'LoginScreen.dart';

class Studentscreen extends StatefulWidget {
  @override
  StudentScreenState createState() => StudentScreenState();
}

class StudentScreenState extends State<Studentscreen> {
  String _studentName = ""; // Placeholder for the teacher's name
  bool _isLoading = true;
  String principalName = ""; // Principal's name
  AudioPlayer? _currentAudioPlayer; // Currently playing audio
  String? _currentPlayingAudioUrl; // Currently playing audio URL

  @override
  void dispose() {
    _currentAudioPlayer?.dispose(); // Dispose audio player
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchStudentName();
  }

  Future<void> _fetchStudentName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Query the teacher's document in Firestore based on the current user's UID
        DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
            .collection('student')
            .doc(user.uid)
            .get();

        if (teacherDoc.exists) {
          setState(() {
            _studentName =
                "${teacherDoc['FirstName']} ${teacherDoc['LastName']}";
            _isLoading = false;
          });
        } else {
          throw Exception("Teacher document not found");
        }
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      setState(() {
        _studentName = "Error fetching name";
        _isLoading = false;
      });
    }
  }

  void _stopCurrentAudio() {
    if (_currentAudioPlayer != null) {
      _currentAudioPlayer?.pause();
      _currentAudioPlayer?.dispose();
      _currentAudioPlayer = null;
      _currentPlayingAudioUrl = null;
    }
  }

  void _playAudio(String audioUrl) {
    if (_currentPlayingAudioUrl == audioUrl) {
      setState(() {
        _currentPlayingAudioUrl = null; // Pause audio if the same is clicked
      });
    } else {
      setState(() {
        _currentPlayingAudioUrl = audioUrl; // Update playing audio
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);
    final principalProvider = Provider.of<PrincipalProvider>(context);

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: Column(
        children: [
          // Top Section
          Stack(
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFF044B89),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                right: 240,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Colors.white.withOpacity(0.15)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                right: 220,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Colors.white.withOpacity(0.15)),
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
                top: 75,
                left: 10,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: NetworkImage(teacherProvider.avatarUrl),
                    ),
                    const SizedBox(width: 15),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      _studentName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 50),
                    _buildLogoutButton(),
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
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Text(
                      'Available Lectures',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  principalProvider.approvedTeacherCards.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        'No approved content available.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                      : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: principalProvider.approvedTeacherCards.length,
                    itemBuilder: (context, index) {
                      final card = principalProvider.approvedTeacherCards[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (card['audioFiles'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: card['audioFiles'].map<Widget>((audioUrl) {
                                    return AudioPlayerWidget(
                                      audioUrl: audioUrl,
                                      onPlay: () => _playAudio(audioUrl),
                                      onStop: _stopCurrentAudio,
                                      isPlaying: _currentPlayingAudioUrl == audioUrl,
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  // Information Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiz Screen',
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AssignmentScreen()),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AnnouncementScreen()),
                            );
                          },
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LessonScreen()),
                            );
                          },
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherScreen()),
                            );
                          },
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HolidayScreen()),
                            );
                          },
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExamsScreen()),
                            );
                          },
                        ),
                        CapsuleListItem(
                          icon: SvgPicture.asset(
                            'assets/images/result_icon.svg',
                            width: 44,
                            height: 44,
                          ),
                          title: 'Add Results',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen()),
                            );
                          },
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

  Widget _buildLogoutButton() {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black26, // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          icon: Icon(Icons.logout_outlined, color: Colors.white),
          label: Text(
            "Logout",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ],
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
