import 'package:flutter/material.dart';

class PhoneLoginViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  String? errorText;

  void validatePhoneNumber() {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      errorText = "Phone number cannot be empty";
    } else if (!RegExp(r'^\d{10,10}$').hasMatch(phone)) {
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
