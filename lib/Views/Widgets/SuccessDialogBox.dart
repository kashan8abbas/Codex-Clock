import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingToSuccessPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      bool isSuccess = false;

      return StatefulBuilder(
        builder: (context, setState) {
          // Simulate loading → success after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (!isSuccess) {
              setState(() {
                isSuccess = true;
              });
              // Auto-dismiss after success shown for 1.5s
              Future.delayed(const Duration(milliseconds: 1500), () {
                Navigator.of(context).pop();
              });
            }
          });

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isSuccess)
                    const CircularProgressIndicator()
                  else
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.green[100],
                      child: Icon(Icons.check, color: Colors.green, size: 40),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    isSuccess ? "Attendance Marked!" : "Marking Attendance...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSuccess ? Colors.green : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


void showLottieSuccessPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'lib/Utils/Animations/success.json',
              width: 150,
              repeat: false,
              onLoaded: (composition) {
                // Auto close after animation duration
                Future.delayed(composition.duration, () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Attendance Marked!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



