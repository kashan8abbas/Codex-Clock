import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  String? selectedCategory;
  String? selectedDay, selectedMonth, selectedYear;
  String selectedGender = "Male";


  // Form validation errors
  String? categoryError;
  String? dayError;
  String? monthError;
  String? yearError;
  String? genderError;


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

    // Gender validation
    if (selectedGender.isEmpty) {
      genderError = "Gender is required";
      isValid = false;
    } else {
      genderError = null;
    }


    notifyListeners();
    return isValid;
  }

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setDateOfBirth(String day, String month, String year) {

    selectedDay = day;
    selectedMonth = month;
    selectedYear = year;

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
