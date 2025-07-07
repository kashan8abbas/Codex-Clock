import 'package:flutter/material.dart';

class CorrectionRequestViewModel extends ChangeNotifier {
  String? selectedDay, selectedMonth, selectedYear;
  String? selectedCheckInHour, selectedCheckInMint;
  String? selectedCheckOutHour, selectedCheckOutMint;
  String _note = "";

  String get note => _note;

  String? dayError;
  String? monthError;
  String? yearError;
  String? selectedCheckInHourError;
  String? selectedCheckInMintError;
  String? selectedCheckOutHourError;
  String? selectedCheckOutMintError;
  String? noteError;

  bool validateForm() {
    bool isValid = true;

    // Date of Birth validation
    if (selectedDay == null) {
      dayError = "Day is required";
      isValid = false;
    } else {
      dayError = null;
    }

    if (selectedMonth == null) {
      monthError = "Month is required";
      isValid = false;
    } else {
      monthError = null;
    }

    if (selectedYear == null) {
      yearError = "Year is required";
      isValid = false;
    } else {
      yearError = null;
    }

    if (selectedCheckInHour == null) {
      selectedCheckInHourError = "Check In Hour is required";
      isValid = false;
    } else {
      selectedCheckInHourError = null;
    }

    if (selectedCheckInMint == null) {
      selectedCheckInMintError = "Check In Minutes is required";
      isValid = false;
    } else {
      selectedCheckInMintError = null;
    }

    if (selectedCheckOutHour == null) {
      selectedCheckOutHourError = "Check Out Hour is required";
      isValid = false;
    } else {
      selectedCheckOutHourError = null;
    }

    if (selectedCheckOutMint == null) {
      selectedCheckOutMintError = "Check Out Minutes is required";
      isValid = false;
    } else {
      selectedCheckOutMintError = null;
    }

    if (note.isEmpty) {
      noteError = "Reason is required";
      isValid = false;
    } else {
      noteError = null;
    }


    notifyListeners();
    return isValid;
  }

  void setDate(String day, String month, String year) {
    selectedDay = day;
    selectedMonth = month;
    selectedYear = year;
    notifyListeners();
  }

  void setCheckInTime(String hour, String mint) {
    selectedCheckInHour = hour;
    selectedCheckInMint = mint;
    notifyListeners();
  }

  void setCheckOutTime(String hour, String mint) {
    selectedCheckOutHour = hour;
    selectedCheckOutMint = mint;
    notifyListeners();
  }

  void setNote(String value) {
    _note = value;
    notifyListeners();
  }

}
