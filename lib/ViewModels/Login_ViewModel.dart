import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  String? errorText;

  void validatePhoneNumber() {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      errorText = "Phone number cannot be empty";
    } else if (!RegExp(r'^\d{10,15}$').hasMatch(phone)) {
      errorText = "Enter a valid phone number";
    } else {
      errorText = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
