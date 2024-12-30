import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../Sub_Screens/class_screen.dart';
import '../Sub_Screens/upload_lecture.dart';
import '../models/audioplayer.dart';
import '../providers/create_topic_provider.dart';
import '../providers/teacher_provider.dart';
import 'LoginScreen.dart';

class TeacherScreen extends StatefulWidget {
  final teacherId = FirebaseAuth.instance.currentUser?.uid;

  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final CreateTopicProvider assignmentProvider = CreateTopicProvider();
  String _teacherName = ""; // Placeholder for the teacher's name
  bool _isLoading = true;
  List<String> audioFiles = []; // This will hold the audio URLs from Firestore
  AudioPlayer? _currentAudioPlayer; // Currently playing audio player
  String? _currentPlayingAudioUrl; // Track which audio URL is currently playing
  @override
  void initState() {
    super.initState();
    _fetchTeacherName();
    _fetchAudioFiles(); // Fetch audio files from Firestore
  }

  @override
  void dispose() {
    _currentAudioPlayer?.dispose(); // Dispose the current audio player
    super.dispose();
  }

  Future<void> _fetchTeacherName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
            .collection('teacher')
            .doc(user.uid)
            .get();

        if (teacherDoc.exists) {
          setState(() {
            _teacherName = "${teacherDoc['FirstName']} ${teacherDoc['LastName']}";
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
        _teacherName = "Error fetching name";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAudioFiles() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Study_material').get();
      setState(() {
        audioFiles = snapshot.docs.map((doc) => (doc['AudioFiles'] as List).cast<String>()).expand((x) => x).toList(); // Ensure correct type
      });
    } catch (e) {
      print("Error fetching audio files: $e");
    }
  }

  void _stopCurrentAudio() {
    if (_currentAudioPlayer != null) {
      _currentAudioPlayer?.pause(); // Pause the current audio
      _currentAudioPlayer?.dispose();
      _currentAudioPlayer = null;
      _currentPlayingAudioUrl = null; // Reset the currently playing audio URL
    }
  }


  void _playAudio(String audioUrl) {
    if (_currentPlayingAudioUrl == audioUrl) {
      // If the same audio is clicked, pause it
      setState(() {
        _currentPlayingAudioUrl = null; // Reset to not playing
      });
    } else {
      setState(() {
        _currentPlayingAudioUrl = audioUrl; // Track currently playing audio URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);
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
                            _teacherName,
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
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned Classes',
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
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ClassCard(
                              title: '9 - A Science',
                              subtitle: 'Islamabad',
                              color: Colors.blueAccent,
                              height: 60.0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClassSheet()),
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
                                  MaterialPageRoute(
                                      builder: (context) => ClassSheet()),
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
                                  MaterialPageRoute(
                                      builder: (context) => ClassSheet()),
                                );
                              },
                            ),
                            // Add more cards with their respective bottom sheets
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lectures List',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // LIST VIEW CODE
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Study_material')
                              .where('TeacherId', isEqualTo: widget.teacherId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'No lectures found.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }

                            final lectureDocs = snapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: lectureDocs.length,
                              itemBuilder: (context, index) {
                                final lecture = lectureDocs[index];
                                final lectureName =
                                    lecture['TopicName'] ?? 'No Name';
                                final lectureDescription =
                                    lecture['TopicDescription'] ??
                                        'No Description';
                                final audioFiles = lecture['AudioFiles'] ?? [];
                                final status =
                                    lecture['Status'] ?? 'UPDATING PROGRESS';

                                return Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          'Lecture Name',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          lectureName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                                backgroundColor: Colors.blue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                status,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                // Delete the lecture
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'Study_material')
                                                    .doc(lecture.id)
                                                    .delete();
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Lecture Description',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          lectureDescription,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Lecture Audio Files',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List<Widget>.generate(
                                              audioFiles.length, (audioIndex) {
                                            final audioUrl =
                                                audioFiles[audioIndex];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: AudioPlayerWidget(
                                                audioUrl: audioUrl,
                                                onPlay: () => _playAudio(audioUrl),
                                                onStop: ()=> _stopCurrentAudio(),
                                                isPlaying: _currentPlayingAudioUrl == audioUrl,
                                              ),

                                            );
                                          }),
                                        ),


                                      ),
                                    ],
                                  ),
                                );
                              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Create_lecture()),
          );
        },
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
