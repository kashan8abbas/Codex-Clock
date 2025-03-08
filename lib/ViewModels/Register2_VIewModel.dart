import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  String? selectedCategory;
  String? selectedDay, selectedMonth, selectedYear;
  String selectedGender = "Male";

  final TextEditingController permanentAddressController =
      TextEditingController();
  final TextEditingController currentAddressController =
      TextEditingController();

  // Form validation errors
  String? categoryError;
  String? dayError;
  String? monthError;
  String? yearError;
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

    // Address validation
    if (permanentAddressController.text.isEmpty) {
      permanentError = "Permanent address is required";
      isValid = false;
    } else {
      permanentError = null;
    }

    if (currentAddressController.text.isEmpty) {
      currentError = "Current address is required";
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

  void setDateOfBirth(String? day, String? month, String? year) {
    List<String> validDays = List.generate(
      31,
      (index) => (index + 1).toString(),
    );
    List<String> validMonths = ["Jan", "Feb", "Mar", "Apr", "May"];
    List<String> validYears = List.generate(
      50,
      (index) => (2025 - index).toString(),
    );

    if (day != null && !validDays.contains(day)) return;
    if (month != null && !validMonths.contains(month)) return;
    if (year != null && !validYears.contains(year)) return;

    selectedDay = day;
    selectedMonth = month;
    selectedYear = year;

    notifyListeners();
  }

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void signUp() {
    // Handle sign-up logic here
    print("Category: $selectedCategory");
    print("DOB: $selectedDay-$selectedMonth-$selectedYear");
    print("Gender: $selectedGender");
    print("Permanent Address: ${permanentAddressController.text}");
    print("Current Address: ${currentAddressController.text}");
  }

  @override
  void dispose() {
    permanentAddressController.dispose();
    currentAddressController.dispose();
    super.dispose();
  }
}
