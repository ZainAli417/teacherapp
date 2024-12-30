import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ollapp/models/audioplayer.dart';
import 'package:provider/provider.dart';

import '../providers/principal_provider.dart';
import 'LoginScreen.dart';
import '../providers/teacher_provider.dart';

class Principalscreen extends StatefulWidget {
  @override
  PrincipalScreenState createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<Principalscreen> {
  String principalName = ""; // Principal's name
  bool _isLoading = true;
  AudioPlayer? _currentAudioPlayer; // Currently playing audio
  String? _currentPlayingAudioUrl; // Currently playing audio URL

  @override
  void initState() {
    super.initState();
    _fetchPrincipalName();
  }

  @override
  void dispose() {
    _currentAudioPlayer?.dispose(); // Dispose audio player
    super.dispose();
  }

  Future<void> _fetchPrincipalName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot principalDoc = await FirebaseFirestore.instance
            .collection('principal')
            .doc(user.uid)
            .get();

        if (principalDoc.exists) {
          setState(() {
            principalName =
                "${principalDoc['FirstName']} ${principalDoc['LastName']}";
            _isLoading = false;
          });
        } else {
          throw Exception("Principal document not found");
        }
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      setState(() {
        principalName = "Error fetching name";
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

    // Redirect to login if user is not authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Principal's Name Section
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
                    principalProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            principalProvider.principalName,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        10, 10, 10, 0), // Reduced vertical padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verified Teachers',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: principalProvider.teacherCards.length,
                          itemBuilder: (context, index) {
                            final teacher =
                                principalProvider.teacherCards[index];
                            final avatarUrl = teacher['avatarUrl'] ??
                                'https://firebasestorage.googleapis.com/v0/b/unisoft-tmp.appspot.com/o/Default%2Fdummy-profile.png?alt=media&token=ebbb29f7-0ab8-4437-b6d5-6b2e4cfeaaf7'; // Default avatar URL if not set.
                            final teacherName =
                                teacher['teacherName'] ?? 'Unknown Teacher';

                            return Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal:
                                      5), // Reduced margin between cards
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(avatarUrl),
                                      radius: 30,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      teacherName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
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
                  const SizedBox(
                    height: 20,
                  ),
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
                  principalProvider.teacherCards.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              'No content uploaded by teachers.',
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
                          itemCount: principalProvider.teacherCards.length,
                          itemBuilder: (context, index) {
                            final card = principalProvider.teacherCards[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Center(
                                      child: Text(
                                        'Uploaded By: ${card['teacherName']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    subtitle: Center(
                                      child: Text(
                                        'Lecture Name: ${card['topicName']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                    child: Text(
                                      'Description: ${card['topicDescription']}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (card['audioFiles'].isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Lecture Audio Files:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ...card['audioFiles'].map((audioUrl) {
                                            return AudioPlayerWidget(
                                              audioUrl: audioUrl,
                                              onPlay: () =>
                                                  _playAudio(audioUrl),
                                              onStop: _stopCurrentAudio,
                                              isPlaying:
                                                  _currentPlayingAudioUrl ==
                                                      audioUrl,
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  Center(
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        String?
                                            selectedStatus; // Tracks the clicked status (Approved/Rejected)

                                        void updateStatus(
                                            String newStatus) async {
                                          try {
                                            await principalProvider
                                                .updateStudyMaterialStatus(
                                                    card['docId'], newStatus);

                                            // Update the UI and show a snackbar
                                            setState(() {
                                              selectedStatus = newStatus;
                                            });
                                            if(selectedStatus=='Approve') {
                                              _showSnackbar_success(context,
                                                "Lecture has been $newStatus");
                                            }
                                            else{
                                              _showSnackbar_fail(context,      "Lecture has been $newStatus");
                                            }

                                          } catch (e) {
                                            // Show an error snackbar
                                            _showSnackbar_fail(context, '$e');
                                          }
                                        }

                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              onPressed: (selectedStatus ==
                                                          null ||
                                                      selectedStatus ==
                                                          'Rejected')
                                                  ? () =>
                                                      updateStatus('Approved')
                                                  : null, // Disable if already approved
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: const StadiumBorder(),
                                              ),
                                              child: Text(
                                                'Approve',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 120),
                                            ElevatedButton(
                                              onPressed: (selectedStatus ==
                                                          null ||
                                                      selectedStatus ==
                                                          'Approved')
                                                  ? () =>
                                                      updateStatus('Rejected')
                                                  : null, // Disable if already rejected
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: const StadiumBorder(),
                                              ),
                                              child: Text(
                                                'Reject',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10,),

                                ],
                              ),
                            );
                          },
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

  void _showSnackbar_success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green.withOpacity(0.8),
        duration: const Duration(seconds: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        dismissDirection: DismissDirection.startToEnd,
      ),
    );
  }

  void _showSnackbar_fail(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red.withOpacity(0.8),
        duration: const Duration(seconds: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        dismissDirection: DismissDirection.startToEnd,
      ),
    );
  }
}
