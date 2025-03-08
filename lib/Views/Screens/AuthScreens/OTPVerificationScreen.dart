import 'package:codex_clock/Views/Screens/HomePages/HomeScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:codex_clock/ViewModels/OTP_ViewModel.dart'; // Import ViewModel

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final OtpViewModel otpViewModel = OtpViewModel(); // Initialize ViewModel

  @override
  void initState() {
    super.initState();
    otpViewModel.startTimer(); // Start countdown timer
  }

  @override
  void dispose() {
    otpViewModel.dispose(); // Clean up timer when screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Confirmation code",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Illustration Image
            SvgPicture.asset(
              "lib/Utils/Images/OTPVerification.svg",
              height: 170,
            ),

            const SizedBox(height: 40),

            // Title & Description
            const Text(
              "Confirm your Phone Number",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Enter the verification code sent to\n+92 3xxxxxxxxx",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),

            const SizedBox(height: 25),

            // OTP Input Fields
            Pinput(
              length: 6,
              defaultPinTheme: PinTheme(
                width: 50,
                height: screenHeight / 16,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromRGBO(236, 0, 60, 1),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Confirm Button
            CustomButton(
              text: "Confirm",
              color: const Color.fromRGBO(236, 0, 60, 1),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Resend Timer
            ValueListenableBuilder<int>(
              valueListenable: otpViewModel.secondsRemaining,
              builder: (context, value, child) {
                return RichText(
                  text: TextSpan(
                    text: "Resending code in ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: "$value ",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: "secs. "),
                      TextSpan(
                        text: " Resend Now",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () => otpViewModel.resetTimer(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
