import 'package:flutter/material.dart';

class AttendanceModel extends ChangeNotifier {
  String _selectedLeaveType = 'All';

  String get selectedLeaveType => _selectedLeaveType;

  // Set Leave Type
  void setLeaveType(String type) {
    _selectedLeaveType = type;
    notifyListeners();
  }

  // Filter Attendance Data
  List<Map<String, dynamic>> filterAttendance(List<Map<String, dynamic>> data) {
    if (_selectedLeaveType == 'All') {
      return data;
    } else {
      return data
          .where((item) => item['status'] == _selectedLeaveType)
          .toList();
    }
  }
}
