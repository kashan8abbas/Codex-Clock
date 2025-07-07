import 'package:flutter/material.dart';

class RegistrationViewModel extends ChangeNotifier {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode cnicFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  String? firstNameError;
  String? lastNameError;
  String? cnicError;
  String? emailError;
  String? phoneError;
  String? passwordError;

  void setCNIC(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    int len = digitsOnly.length;

    if (len >= 5) {
      formatted += '${digitsOnly.substring(0, 5)}-';
      if (len >= 12) {
        formatted += '${digitsOnly.substring(5, 12)}-${digitsOnly.substring(12, 13)}';
      } else if (len > 5) {
        formatted += digitsOnly.substring(5, len);
      }
    } else {
      formatted = digitsOnly;
    }

    cnicController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    notifyListeners();
  }

  void setPhone(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    int len = digitsOnly.length;

    if (len > 3) {
      formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, len)}';
    } else {
      formatted = digitsOnly;
    }

    // Limit total characters to 11 (including the dash)
    if (formatted.length > 11) {
      formatted = formatted.substring(0, 11);
    }

    phoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    notifyListeners();
  }

  bool validateForm() {
    bool isValid = true;

    if (firstNameController.text.isEmpty) {
      firstNameError = "First name is required";
      isValid = false;
    } else {
      firstNameError = null;
    }

    if (lastNameController.text.isEmpty) {
      lastNameError = "Last name is required";
      isValid = false;
    } else {
      lastNameError = null;
    }

    if(cnicController.text.isEmpty) {
      cnicError = "CNIC is required";
      isValid = false;
    }
    else if (!RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(cnicController.text)) {
      cnicError = "Enter a valid CNIC (XXXXX-XXXXXXX-X)";
      isValid = false;
    } else {
      cnicError = null;
    }

    if (emailController.text.isEmpty) {
      emailError = "Email address is required";
      isValid = false;
    }
    else if(!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ).hasMatch(emailController.text)) {
      emailError = "Enter a Valid Email";
      isValid = false;
    } else {
      emailError = null;
    }

    if (phoneController.text.isEmpty) {
      phoneError = "Phone number is required";
      isValid = false;
    }
    else if (!RegExp(r'^\d{3}-\d{7}').hasMatch(phoneController.text)) {
      phoneError = "Enter a valid Phone number";
    } else {
      phoneError = null;
    }

    if(passwordController.text.isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    }
    else if(passwordController.text.length < 6) {
      passwordError = "Password must be at least 6 characters long";
      isValid = false;
    }
    else {
      passwordError = null;
    }

    notifyListeners();
    return isValid;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    cnicController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    cnicFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
