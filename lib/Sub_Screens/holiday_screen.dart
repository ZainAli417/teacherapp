import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Navbar.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  _HolidayScreenState createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  DateTime _selectedDate = DateTime.now();

  void _incrementMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
  }

  void _decrementMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    int firstDayOffset =
        DateTime(_selectedDate.year, _selectedDate.month, 1).weekday % 7;
    int totalGridItems = daysInMonth + firstDayOffset;

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
            "Holidays",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF044B89),

        ),

      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(-1, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // reduced padding
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(
                                10)), // simplified border radius
                            color: Color(0xFF044B89),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20), // set icon size to 20
                            onPressed: _decrementMonth,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMM().format(_selectedDate),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(
                                10)), // simplified border radius
                            color: Color(0xFF044B89),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white,
                                size:
                                    20), // set icon size to 20 and changed icon to arrow_forward_ios
                            onPressed: _incrementMonth,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 300, // specify the height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                        .map(
                          (day) => Text(
                        day,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF044B89),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      itemCount: totalGridItems,
                      itemBuilder: (context, index) {
                        if (index < firstDayOffset) {
                          return const SizedBox.shrink(); // Empty cell before the first day of the month
                        }

                        int day = index - firstDayOffset + 1;

                        return Center(
                          child: Text(
                            '$day',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: day <= daysInMonth ? Colors.black87 : Colors.grey, // changed the condition to display next month's dates in grey
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
