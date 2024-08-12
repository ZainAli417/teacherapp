import 'package:flutter/material.dart';
import 'package:ollapp/Navbar.dart';

class SplashProvider with ChangeNotifier {
  void navigateToLogin(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => navbar()),
      );

    });
  }
}
