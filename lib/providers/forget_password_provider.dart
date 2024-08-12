import 'package:flutter/material.dart';

class ForgotPasswordProvider with ChangeNotifier {
  String _email = '';
  bool _isLoading = false;

  String get email => _email;
  bool get isLoading => _isLoading;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  Future<void> submitForgotPassword() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace this with your backend API call to reset the password.
      await Future.delayed(Duration(seconds: 2)); // Mock delay

      // Handle success response
    } catch (error) {
      // Handle error response
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
