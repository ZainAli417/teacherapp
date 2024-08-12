import 'package:flutter/material.dart';

import '../UI/TeacherScreen.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    if (email == 'admin@gmail.com' && password == '123456') {
      // Navigate to the HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TeacherScreen()),
      );
    } else {
      print('Invalid credentials');
    }
  }
}
