import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


void showLottieSuccessPopup(BuildContext context, String msg, bool status) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: status ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'lib/Utils/Animations/success.json',
              width: 150,
              repeat: true,
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(236, 0, 60, 1),
              ),
            ),
          ],
        ) : SizedBox(
          height: 150,
          child: Center(child: Text(
            msg,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(236, 0, 60, 1),
            ),
          ),),
        ),
      ),
    ),
  );
}



