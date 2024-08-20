import 'package:flutter/material.dart';
import 'package:ollapp/providers/exams_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Navbar.dart';

class ExamsScreen extends StatefulWidget {
  @override
  _ExamsScreenState createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  String selectedTab = 'All Exams';

  @override
  Widget build(BuildContext context) {
    final examData = Provider.of<ExamsProvider>(context).getExamsByTab(selectedTab);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // Set the height
        child: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/images/back_icon.svg',
              width: 25, // Adjust the size as needed
              height: 25, // Adjust the size as needed
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => navbar()),
              );
            },
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          title: Text(
            "Exams",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF044B89),

        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab('All Exams'),
                _buildTab('Upcoming'),
                _buildTab('Ongoing'),
              ],
            ),
          ),
          Expanded(
            child: examData.isEmpty
                ? Center(
              child: SvgPicture.asset(
                'assets/images/SWR.svg', // Replace with your asset path
                width:350,
              ),
            )
                : ListView.builder(
              itemCount: examData.length,
              itemBuilder: (context, index) {
                final exam = examData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        '${exam['class']}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                      ),
                      subtitle: Text(
                        '${exam['topic']}',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        '${exam['date']}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF044B89) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          tab,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
