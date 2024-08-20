import 'package:flutter/material.dart';
import 'package:ollapp/Navbar.dart';
import 'package:ollapp/Sub_Screens/announcement_screen.dart';
import 'package:ollapp/Sub_Screens/class_screen.dart';
import 'package:ollapp/Sub_Screens/create_lesson.dart';
import 'package:ollapp/Sub_Screens/create_topic.dart';
import 'package:ollapp/Sub_Screens/lesson_screen.dart';
import 'package:ollapp/Sub_Screens/topic_screen.dart';
import 'package:ollapp/UI/ProfileScreen.dart';
import 'package:ollapp/UI/TeacherScreen.dart';
import 'package:ollapp/providers/assingment_provider.dart';
import 'package:ollapp/providers/create_announcement_provider.dart';
import 'package:ollapp/providers/create_assignment_provider.dart';
import 'package:ollapp/providers/attendance_provider.dart';
import 'package:ollapp/providers/class_sub_screen_provider.dart';
import 'package:ollapp/providers/announcement_provider.dart';
import 'package:ollapp/providers/create_lesson_provider.dart';
import 'package:ollapp/providers/exams_provider.dart';
import 'package:ollapp/providers/lesson_provider.dart';
import 'package:ollapp/providers/profile_provider.dart';
import 'package:ollapp/providers/result_Provider.dart';
import 'package:ollapp/providers/setting_provider.dart';
import 'package:ollapp/providers/shedule_provider.dart';
import 'package:ollapp/providers/teacher_provider.dart';
import 'package:provider/provider.dart';
import 'Sub_Screens/assingment_screen.dart';
import 'Sub_Screens/create_assignment_screen.dart';
import 'Sub_Screens/attendance_screen.dart';
import 'Sub_Screens/holiday_screen.dart';
import 'Sub_Screens/results.dart';
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


        ChangeNotifierProvider(create: (_) => CreateAssingmentProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),


        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => CreateAnnouncementProvider()),


        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => CreateLessonProvider()),

        ChangeNotifierProvider(create: (_) => resultProvider()),
        ChangeNotifierProvider(create: (_) => ExamsProvider()),

      ],
      child: MaterialApp(
        title: 'Teacher App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(), // Initial screen change to splash for now testing
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => TeacherScreen(),
          '/forget_password': (context) => ForgotPasswordScreen(),
          '/teacher': (context) => TeacherScreen(),
          '/profile': (context) => ProfileScreen(),
          '/schedule': (context) => ScheduleScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/class_sheet': (context) => ClassSheet(),
          '/attendance': (context) => const AttendanceScreen(),
          '/announcement': (context) => const AnnouncementScreen(),

          '/create_assignment': (context) => const Create_Assingment(),
          '/assignment': (context) => const AssignmentScreen(),

          '/topic': (context) => const TopicScreen(),
          '/create_topic': (context) => const Create_Topic(),

          '/lesson': (context) => const LessonScreen(),
          '/create_lesson': (context) => const Create_Lesson(),
          '/holiday': (context) => const HolidayScreen(),
          '/result': (context) =>  ResultScreen(),



        },
      ),
    );
  }
}
