import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/setting_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Map<String, String>> settingsItems = [
    {"icon": "translate", "title": "English"},
    {"icon": "password", "title": "Change password"},
    {"icon": "privacy_tip", "title": "Privacy Policy"},
    {"icon": "description", "title": "Terms & Condition"},
    {"icon": "info", "title": "About Us"},
    {"icon": "contact_support", "title": "Contact us"},
    {"icon": "star", "title": "Rate Us"},
    {"icon": "share", "title": "Share"},
  ];

  @override
  void initState() {
    super.initState();
    _addItems();
  }

  void _addItems() async {
    for (int i = 0; i < settingsItems.length; i++) {
      await Future.delayed(Duration(milliseconds: 150));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90), // Set the height
          child: AppBar(
            backgroundColor: const Color(0xFF125390),
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
    return AnimatedList(
      key: _listKey,
      initialItemCount: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemBuilder: (context, index, animation) {
        return _buildSettingsListItem(settingsItems[index], animation);
      },
    );
  }

  Widget _buildSettingsListItem(Map<String, String> item, Animation<double> animation) {
    IconData iconData;

    switch (item['icon']) {
      case 'translate':
        iconData = Icons.translate;
        break;
      case 'password':
        iconData = Icons.password;
        break;
      case 'privacy_tip':
        iconData = Icons.privacy_tip;
        break;
      case 'description':
        iconData = Icons.description;
        break;
      case 'info':
        iconData = Icons.info;
        break;
      case 'contact_support':
        iconData = Icons.contact_support;
        break;
      case 'star':
        iconData = Icons.star;
        break;
      case 'share':
        iconData = Icons.share;
        break;
      default:
        iconData = Icons.help; // Fallback icon
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
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
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  iconData,
                  color: Colors.white, // Ensure the icon is white for visibility
                ),
              ),
            ),
            const SizedBox(width: 20),
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
            const Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            ),
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
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
          const SizedBox(height: 8),
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
