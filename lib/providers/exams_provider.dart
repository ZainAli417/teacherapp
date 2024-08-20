import 'package:flutter/material.dart';

class ExamsProvider with ChangeNotifier {
  // Sample data for exams
  final List<Map<String, String>> _allExams = [
    {'class': '9-A Lahore', 'topic': 'Mid Year', 'date': '30-11-2024'},
    {'class': '9-B Rawalpindi', 'topic': 'First Chapter', 'date': '21-08-2024'},
    {'class': '9-C Islamabad', 'topic': 'unit test 1', 'date': '23-08-2024'},
    {'class': '10-A Lahore', 'topic': 'unit test 1', 'date': '23-08-2024'},
    {'class': '10-B Rawalpindi', 'topic': 'Unit test 1', 'date': '01-06-2025'},
    {'class': '10-C Islamabad', 'topic': 'Unit Test 2', 'date': '24-06-2025'},
  ];

  // Tabs filter
  List<Map<String, String>> getExamsByTab(String tab) {
    if (tab == 'All Exams') return _allExams;
    // For now return filtered data based on some dummy logic
    if (tab == 'Upcoming') {
      return _allExams.where((exam) => DateTime.parse('2023-08-23').isAfter(DateTime.now())).toList();
    }
    if (tab == 'Ongoing') {
      return _allExams.where((exam) => DateTime.parse('2023-08-21').isBefore(DateTime.now())).toList();
    }
    return [];
  }
}
