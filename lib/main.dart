import 'package:flutter/material.dart';
import 'package:ollapp/UI/ProfileScreen.dart';
import 'package:ollapp/UI/TeacherScreen.dart';
import 'package:ollapp/providers/profile_provider.dart';
import 'package:ollapp/providers/setting_provider.dart';
import 'package:ollapp/providers/shedule_provider.dart';
import 'package:ollapp/providers/teacher_provider.dart';
import 'package:provider/provider.dart';
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
      ],
      child: MaterialApp(
        title: 'Teacher App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(), // Initial screen
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => TeacherScreen(),
          '/forget_password': (context) => ForgotPasswordScreen(),
          '/teacher': (context) => TeacherScreen(),
          '/profile': (context) => ProfileScreen(),
          '/schedule': (context) =>ScheduleScreen (),
          '/settings': (context) =>SettingsScreen (),



        },
      ),
    );
  }
}
