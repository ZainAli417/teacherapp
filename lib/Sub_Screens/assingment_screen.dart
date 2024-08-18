import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ollapp/Navbar.dart';

import '../providers/assingment_provider.dart';
import '../providers/create_assignment_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final AssignmentProvider assignmentProvider = AssignmentProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
