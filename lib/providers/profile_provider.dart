import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _avatarUrl = "https://firebasestorage.googleapis.com/v0/b/unisoft-tmp.appspot.com/o/Default%2Fdummy-profile.png?alt=media&token=ebbb29f7-0ab8-4437-b6d5-6b2e4cfeaaf7";
  final String _teacherName = "Zain Ali";
  final String _email = "teacher@gmail.com";
  final String _phoneNumber = "+923196051338";
  final String _dateOfBirth = "23-05-2003";
  final String _gender = "Male";
  final String _qualification = "BS Computer Science";
  final String _currentAddress = "Islamabad";
  final String _permanentAddress = "Lahore";

  String get avatarUrl => _avatarUrl;
  String get teacherName => _teacherName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get dateOfBirth => _dateOfBirth;
  String get gender => _gender;
  String get qualification => _qualification;
  String get currentAddress => _currentAddress;
  String get permanentAddress => _permanentAddress;

  // Function to update the avatar URL
  void updateAvatarUrl(String url) {
    _avatarUrl = url;
    notifyListeners();
  }

// Other update functions can be added here as needed
}
