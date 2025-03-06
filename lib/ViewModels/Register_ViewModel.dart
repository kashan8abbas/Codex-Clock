import 'package:flutter/material.dart';

class RegistrationViewModel extends ChangeNotifier {
  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form validation errors
  String? firstNameError;
  String? lastNameError;
  String? cnicError;
  String? emailError;
  String? mobileError;
  String? passwordError;

  bool validateForm() {
    bool isValid = true;

    // First name validation
    if (firstNameController.text.isEmpty) {
      firstNameError = "First name is required";
      isValid = false;
    } else {
      firstNameError = null;
    }

    // Last name validation
    if (lastNameController.text.isEmpty) {
      lastNameError = "Last name is required";
      isValid = false;
    } else {
      lastNameError = null;
    }

    // CNIC validation (Pakistan format check)
    if (cnicController.text.isEmpty ||
        !RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(cnicController.text)) {
      cnicError = "Enter a valid CNIC (XXXXX-XXXXXXX-X)";
      isValid = false;
    } else {
      cnicError = null;
    }

    // Email validation
    if (emailController.text.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
        ).hasMatch(emailController.text)) {
      emailError = "Enter a valid email";
      isValid = false;
    } else {
      emailError = null;
    }

    // Mobile number validation (Pakistan format check)
    if (mobileController.text.isEmpty ||
        !RegExp(r'^\d{11}$').hasMatch(mobileController.text)) {
      mobileError = "Enter a valid 11-digit mobile number";
      isValid = false;
    } else {
      mobileError = null;
    }

    // Password validation
    if (passwordController.text.length < 6) {
      passwordError = "Password must be at least 6 characters";
      isValid = false;
    } else {
      passwordError = null;
    }

    notifyListeners(); // Update UI if needed
    return isValid;
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    cnicController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
  }
}
