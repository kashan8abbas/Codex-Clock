import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  String? selectedCategory;
  String? selectedDayDOB, selectedMonthDOB, selectedYearDOB;
  String? selectedDayJD, selectedMonthJD, selectedYearJD;
  String selectedGender = "";
  final TextEditingController permanentController = TextEditingController();
  final TextEditingController currentController = TextEditingController();

  final FocusNode permanentFocusNode = FocusNode();
  final FocusNode currentFocusNode = FocusNode();


  // Form validation errors
  String? categoryError;
  String? dayDOBError;
  String? monthDOBError;
  String? yearDOBError;
  String? dayJDError;
  String? monthJDError;
  String? yearJDError;
  String? genderError;
  String? permanentError;
  String? currentError;


  bool validateForm() {
    bool isValid = true;

    // Category validation
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      categoryError = "Category is required";
      isValid = false;
    } else {
      categoryError = null;
    }

    // Date of Birth validation
    if (selectedDayDOB == null) {
      dayDOBError = "Day is required";
      isValid = false;
    } else {
      dayDOBError = null;
    }

    if (selectedMonthDOB == null) {
      monthDOBError = "Month is required";
      isValid = false;
    } else {
      monthDOBError = null;
    }

    if (selectedYearDOB == null) {
      yearDOBError = "Year is required";
      isValid = false;
    } else {
      yearDOBError = null;
    }

    if (selectedDayJD == null) {
      dayJDError = "Day is required";
      isValid = false;
    } else {
      dayJDError = null;
    }

    if (selectedMonthJD == null) {
      monthJDError = "Month is required";
      isValid = false;
    } else {
      monthJDError = null;
    }

    if (selectedYearJD == null) {
      yearJDError = "Year is required";
      isValid = false;
    } else {
      yearJDError = null;
    }

    // Gender validation
    if (selectedGender.isEmpty) {
      genderError = "Gender is required";
      isValid = false;
    } else {
      genderError = null;
    }

    if(permanentController.text.isEmpty) {
      permanentError = "Permanent Address is required";
      isValid = false;
    } else {
      permanentError = null;
    }

    if(currentController.text.isEmpty) {
      currentError = "Current Address is required";
      isValid = false;
    } else {
      currentError = null;
    }

    notifyListeners();
    return isValid;
  }

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setDateOfBirth(String day, String month, String year) {

    selectedDayDOB = day;
    selectedMonthDOB = month;
    selectedYearDOB = year;

    notifyListeners();
  }

  void setDateOfJoining(String day, String month, String year) {

    selectedDayJD = day;
    selectedMonthJD = month;
    selectedYearJD = year;

    notifyListeners();
  }

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }


  @override
  void dispose() {

    super.dispose();
  }
}
