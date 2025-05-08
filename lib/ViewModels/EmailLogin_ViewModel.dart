import 'package:flutter/material.dart';

class EmailLoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  String? emailErrorText;
  String? passwordErrorText;

  void checkEmail() {
    if (emailController.text.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
        ).hasMatch(emailController.text)) {
      emailErrorText = "Enter a valid email";
    } else {
      emailErrorText = null;
    }
  }

  void checkPassword() {
    if(passwordController.text.isEmpty) {
      passwordErrorText = "Enter Password";
    }
    else {
      passwordErrorText = null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
