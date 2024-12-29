import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollapp/UI/PrincipalScreen.dart';
import 'package:ollapp/UI/StudentScreen.dart';
import 'UI/ProfileScreen.dart';
import 'UI/SettingsScreen.dart';
import 'UI/SheduleScreen.dart';
import 'UI/TeacherScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class navbar extends StatefulWidget {
  @override
  _navbarState createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  int _currentIndex = 0;
  late Widget _homeScreen;
  bool _loadingHomeScreen = true;

  final List<Widget> _commonScreens = [
    ScheduleScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialScreen();
  }

  Future<void> _loadInitialScreen() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check Firestore to determine the user's role
        DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
            .collection('teacher')
            .doc(user.uid)
            .get();
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('student')
            .doc(user.uid)
            .get();
        DocumentSnapshot principalDoc = await FirebaseFirestore.instance
            .collection('principal')
            .doc(user.uid)
            .get();

        if (teacherDoc.exists) {
          _homeScreen = TeacherScreen();
        } else if (studentDoc.exists) {
          _homeScreen = Studentscreen();
        } else if (principalDoc.exists) {
          _homeScreen = Principalscreen();
        } else {
          throw Exception('Role not found for user.');
        }
      } else {
        throw Exception('No user logged in.');
      }
    } catch (e) {
      _homeScreen = Center(
        child: Text('Error loading home screen: $e'),
      );
    } finally {
      setState(() {
        _loadingHomeScreen = false;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loadingHomeScreen
          ? Center(child: CircularProgressIndicator())
          : IndexedStack(
        index: _currentIndex,
        children: [
          _homeScreen,
          ..._commonScreens,
        ],
      ),
      bottomNavigationBar: FloatingNavbar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

class FloatingNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  FloatingNavbar({required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 0
                        ? 'assets/images/home_active_icon.svg'
                        : 'assets/images/home_icon.svg',
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 1
                        ? 'assets/images/schedule_active.svg'
                        : 'assets/images/schedule.svg',
                  ),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 2
                        ? 'assets/images/profile_active.svg'
                        : 'assets/images/profile.svg',
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    currentIndex == 3
                        ? 'assets/images/setting_active.svg'
                        : 'assets/images/setting.svg',
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
