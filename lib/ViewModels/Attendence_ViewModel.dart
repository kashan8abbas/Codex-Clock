import 'package:flutter/material.dart';

import '../Models/Attendance_Moldel.dart';
import '../Services/user_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  List<AttendanceModel> _data = [];
  String _selectedLeaveType = 'All';

  final List<String> months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  int _selectedMonth = DateTime.now().month - 1;
  int _selectedYear = DateTime.now().year;

  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;



  List<AttendanceModel> get data => _data;
  String get selectedLeaveType => _selectedLeaveType;

  void setMonth(int index, int workingTime) {
    _data = [];
    _selectedMonth = index;
    fetchRecords(index+1, workingTime);
    notifyListeners();
  }

  void setData(List<AttendanceModel> fetchedData) {
    _data = fetchedData;
    notifyListeners();
  }

  void setLeaveType(String type) {
    _selectedLeaveType = type;
    notifyListeners();
  }

  List<AttendanceModel> filterAttendance(List<AttendanceModel> data) {
    if (_selectedLeaveType == 'All') {
      return data;
    } else {
      return data
          .where((item) => item.status == _selectedLeaveType)
          .toList();
    }
  }

  void fetchRecords(int month, int workingTime) async {
    await UserService().fetchAttendanceForMonth(month: month, workingTime: workingTime).then((result) {
      _data = result;
      notifyListeners();
    });
  }
}
