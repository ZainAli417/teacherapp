import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/profile_provider.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Colors.white,
        elevation: 0, // Optional: Remove shadow under the AppBar
        flexibleSpace: Stack(
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xFF125390),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Positioned(
              top: 45,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(profileProvider.avatarUrl),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Reduce top padding to decrease space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Center(
                child: Text(
                  profileProvider.teacherName,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Text(
                'Personal Details',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildInfoItem(
                context,
                icon: 'assets/images/user_pro_icon.svg',
                title: 'Email',
                subtitle: profileProvider.email,
              ),
              _buildInfoItem(
                context,
                icon: 'assets/images/phone-call.svg',
                title: 'Phone Number',
                subtitle: profileProvider.phoneNumber,
              ),
              _buildInfoItem(
                context,
                icon: 'assets/images/user_pro_dob_icon.svg',
                title: 'Date of Birth',
                subtitle: profileProvider.dateOfBirth,
              ),
              _buildInfoItem(
                context,
                icon: 'assets/images/gender.svg',
                title: 'Gender',
                subtitle: profileProvider.gender,
              ),
              _buildInfoItem(
                context,
                icon: 'assets/images/qualification.svg',
                title: 'Qualification',
                subtitle: profileProvider.qualification,
              ),
              _buildInfoItem(
                context,
                icon: 'assets/images/user_pro_address_icon.svg',
                title: 'Current Address',
                subtitle: profileProvider.currentAddress,
              ),
              _buildInfoItem(
                context,
                icon: 'assets/images/user_pro_address_icon.svg',
                title: 'Permanent Address',
                subtitle: profileProvider.permanentAddress,
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: FloatingNavbar(), // Assuming FloatingNavbar is your bottom nav widget
    );
  }

  Widget _buildInfoItem(BuildContext context,
      {required String icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF125390),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              icon,
              width: 35,
              height: 30,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
