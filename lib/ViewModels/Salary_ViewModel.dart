import 'package:flutter/material.dart';

class SalaryViewModel extends ChangeNotifier {
  String _selectedLeaveType = "Earning";

  String get selectedLeaveType => _selectedLeaveType;

  void setLeaveType(String type) {
    _selectedLeaveType = type;
    notifyListeners();
  }

}
