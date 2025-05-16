import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utilities {

  void errorMsg (String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromRGBO(236, 0, 60, 1),
        textColor: Colors.white,
        fontSize: 16.0

    );
  }

  void successMsg (String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green.shade300,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void getMessageFromErrorCode(var e) {
    switch (e) {
      case "INVALID-CREDENTIAL":
      case "invalid-credential":
        return errorMsg("Wrong Phone no or Password, Try again");
      case "NETWORK-REQUEST-FAILED":
      case "network-request-failed":
        return errorMsg("No Internet Connection");
      case "USER-DISABLED":
      case "user-disabled":
        return errorMsg("User disabled.");
      case "EMAIL-ALREADY-IN-USE":
      case "email-already-in-use":
        return errorMsg("Account already exist. Go to login page");
      case "INVALID-EMAIL":
      case "invalid-email":
        return errorMsg("Email address is invalid.");
      case "WEAK-PASSWORD":
      case "weak-password":
        return errorMsg("Your password must be at least 6 Characters");
      default:
        return errorMsg("Something went wrong, please try again later.");
    }
  }
}