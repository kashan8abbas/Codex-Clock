import 'package:flutter/material.dart';

class RegistrationViewModel extends ChangeNotifier {
  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();
  final TextEditingController currentAddressController = TextEditingController();

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode cnicFocusNode = FocusNode();
  final FocusNode permanentAddressFocusNode = FocusNode();
  final FocusNode currentAddressFocusNode = FocusNode();


  // Form validation errors
  String? firstNameError;
  String? lastNameError;
  String? cnicError;
  String? permanentError;
  String? currentError;

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
    if (cnicController.text.isEmpty |
        !RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(cnicController.text)) {
      cnicError = "Enter a valid CNIC (XXXXX-XXXXXXX-X)";
      isValid = false;
    } else {
      cnicError = null;
    }

    // Mobile number validation (Pakistan format check)
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


    notifyListeners(); // Update UI if needed
    return isValid;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    cnicController.dispose();
    permanentAddressController.dispose();
    currentAddressController.dispose();
    super.dispose();
  }
}
