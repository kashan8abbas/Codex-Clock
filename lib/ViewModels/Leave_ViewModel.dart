import 'package:flutter/material.dart';

class ApplyLeaveViewModel extends ChangeNotifier {
  String _selectedLeaveType = "Casual";
  DateTime _selectedDate = DateTime.now();
  String _note = "";

  String get selectedLeaveType => _selectedLeaveType;
  DateTime get selectedDate => _selectedDate;
  String get note => _note;

  void setLeaveType(String type) {
    _selectedLeaveType = type;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setNote(String value) {
    _note = value;
    notifyListeners();
  }

  // void submitLeave() {
  //   // Handle leave submission logic here
  //   print("Leave Type: $_selectedLeaveType");
  //   print("Selected Date: $_selectedDate");
  //   print("Note: $_note");
  // }
}
