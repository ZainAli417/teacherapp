import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/setting_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90), // Set the height
          child: AppBar(
            backgroundColor: Color(0xFF125390),
            title: Text(
              "Settings",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
        ),

        body: Column(
          children: [
            Expanded(child: _buildSettingsList()),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    final List<Map<String, String>> settingsItems = [
      {"icon": "assets/images/language.svg", "title": "English"},
      {"icon": "assets/images/language.svg", "title": "Change password"},
      {"icon": "assets/images/language.svg", "title": "Privacy Policy"},
      {"icon": "assets/images/language.svg", "title": "Terms & Condition"},
      {"icon": "assets/images/user_pro_info.svg", "title": "About Us"},
      {"icon": "assets/images/language.svg", "title": "Contact us"},
      {"icon": "assets/images/language.svg", "title": "Rate Us"},
      {"icon": "assets/images/share_button.svg", "title": "Share"},
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: settingsItems.length,
      itemBuilder: (context, index) {
        final item = settingsItems[index];
        return _buildSettingsListItem(item, index);
      },
    );
  }

  Widget _buildSettingsListItem(Map<String, String> item, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF125390), // Blue circular background
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                item['icon']!,
                color: Colors.white, // Ensure the icon is white for visibility
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              item['title']!,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black, // Text color changed to black
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            ),
            icon: Icon(Icons.power_settings_new, color: Colors.white),
            label: Text(
              "Logout",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              // Handle logout logic
            },
          ),
          SizedBox(height: 8),
          Text(
            "App Version 1.1.1 ZBMTech",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

}
