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
      appBar: _buildAppBar(context, profileProvider),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.teacherData != null
          ? _buildProfileContent(context, profileProvider)
          : const Center(child: Text('No data available')),
    );
  }

  AppBar _buildAppBar(BuildContext context, ProfileProvider profileProvider) {
    const defaultAvatarUrl =
        'https://firebasestorage.googleapis.com/v0/b/unisoft-tmp.appspot.com/o/Default%2Fdummy-profile.png?alt=media&token=ebbb29f7-0ab8-4437-b6d5-6b2e4cfeaaf7'; // Fallback image URL

    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/images/back_icon.svg',
          color: const Color(0xFF044B89),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: Stack(
        children: [
          Container(
            height: 130,
            decoration: const BoxDecoration(
              color: Color(0xFF044B89),
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
              child: CircleAvatar(
                radius: 38,
                backgroundImage: NetworkImage(
                  profileProvider.teacherData?.avatarUrl?.isNotEmpty == true
                      ? profileProvider.teacherData!.avatarUrl
                      : defaultAvatarUrl, // Fallback to default image if avatarUrl is empty
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileProvider profileProvider) {
    final teacher = profileProvider.teacherData!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Center(
            child: Text(
              teacher.teacherName,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          _buildSectionTitle('Personal Details'),
          const SizedBox(height: 10),
          _buildInfoItem(context, 'assets/images/user_pro_icon.svg', 'Email', teacher.email),
          _buildInfoItem(context, 'assets/images/phone-call.svg', 'Phone Number', teacher.phoneNumber),
          _buildInfoItem(context, 'assets/images/user_pro_dob_icon.svg', 'Date of Birth', teacher.dateOfBirth),
          _buildInfoItem(context, 'assets/images/gender.svg', 'Gender', teacher.gender),
          _buildInfoItem(context, 'assets/images/qualification.svg', 'Qualification', teacher.qualification),
          _buildInfoItem(context, 'assets/images/user_pro_address_icon.svg', 'Current Address', teacher.currentAddress),
          _buildInfoItem(context, 'assets/images/user_pro_address_icon.svg', 'Permanent Address', teacher.permanentAddress),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF044B89),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              icon,
              width: 35,
              height: 30,
            ),
          ),
          const SizedBox(width: 16),
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
