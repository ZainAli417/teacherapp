import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ollapp/Navbar.dart';
import 'package:ollapp/UI/LoginScreen.dart';

class SplashProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> navigateToNextScreen(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));

    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => navbar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
