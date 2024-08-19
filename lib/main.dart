import 'package:flutter/material.dart';
import 'package:ollapp/Navbar.dart';
import 'package:ollapp/Sub_Screens/class_screen.dart';
import 'package:ollapp/UI/ProfileScreen.dart';
import 'package:ollapp/UI/TeacherScreen.dart';
import 'package:ollapp/providers/create_assignment_provider.dart';
import 'package:ollapp/providers/attendance_provider.dart';
import 'package:ollapp/providers/class_sub_screen_provider.dart';
import 'package:ollapp/providers/profile_provider.dart';
import 'package:ollapp/providers/setting_provider.dart';
import 'package:ollapp/providers/shedule_provider.dart';
import 'package:ollapp/providers/teacher_provider.dart';
import 'package:provider/provider.dart';
import 'Sub_Screens/assingment_screen.dart';
import 'Sub_Screens/create_assignment_screen.dart';
import 'Sub_Screens/attendance_screen.dart';
import 'UI/ForgetPasswordScreen.dart';
import 'UI/LoginScreen.dart';
import 'UI/SettingsScreen.dart';
import 'UI/SheduleScreen.dart';
import 'UI/SplashScreen.dart';
import 'providers/splash_provider.dart';
import 'providers/login_provider.dart';
import 'providers/forget_password_provider.dart';

void main() {
  runApp(TeacherApp());
}

class TeacherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => Sub_screen_Provider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        //ChangeNotifierProvider(create: (_) => Create_Assingment()),
        ChangeNotifierProvider(create: (_) => CreateAssingmentProvider()),
      ],
      child: MaterialApp(
        title: 'Teacher App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: navbar(), // Initial screen change to splash for now testing
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => TeacherScreen(),
          '/forget_password': (context) => ForgotPasswordScreen(),
          '/teacher': (context) => TeacherScreen(),
          '/profile': (context) => ProfileScreen(),
          '/schedule': (context) => ScheduleScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/class_sheet': (context) => ClassSheet(),
          '/attendance': (context) => AttendanceScreen(),
          '/create_assignment': (context) => Create_Assingment(),
          '/assignment': (context) => AssignmentScreen(),
        },
      ),
    );
  }
}
