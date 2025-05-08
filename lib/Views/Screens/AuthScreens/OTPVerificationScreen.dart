import 'package:codex_clock/Services/auth_service.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/Views/Screens/HomePages/HomeScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:codex_clock/ViewModels/OTP_ViewModel.dart';
import 'package:provider/provider.dart'; // Import ViewModel

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNo;
  final String verificationId;
  final bool isSignUp;
  final String? firstName;
  final String? lastName;
  final String? cnic;
  final String? email;
  final String? phone;
  final String? password;
  final String? category;
  final Map<String, dynamic>? dateOfBirth;
  final String? gender;
  final String? permanentAddress;
  final String? currentAddress;
  const OtpVerificationScreen({super.key,
    required this.phoneNo,
    required this.verificationId,
    required this.isSignUp,
    this.firstName,
    this.lastName,
    this.cnic,
    this.email,
    this.phone,
    this.password,
    this.category,
    this.dateOfBirth,
    this.gender,
    this.permanentAddress,
    this.currentAddress
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final OtpViewModel otpViewModel = OtpViewModel(); // Initialize ViewModel

  final AuthService _authService = AuthService();

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
    final loadingViewModel = Provider.of<LoadingViewModel>(context, listen: true);
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "lib/Utils/Images/OTPVerification.svg",
              height: 170,
            ),
            // Title & Description
            Column(
              children: [
                const Text(
                  "Confirm your Phone Number",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "Enter the verification code sent to\n+92 ${widget.phoneNo}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            // OTP Input Fields
            Pinput(
              length: 6,
              controller: otpViewModel.otpController,
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
            // Confirm Button
            CustomButton(
              text: "Confirm",
              color: const Color.fromRGBO(236, 0, 60, 1),
              onPressed: () {
                if(otpViewModel.otpController.text.length >= 6) {
                  loadingViewModel.setLoading(true);
                  if(widget.isSignUp) {
                    _authService.signUpService(
                        verificationId: widget.verificationId,
                        smsCode: otpViewModel.otpController.text,
                        firstName: widget.firstName ?? '',
                        lastName: widget.lastName ?? '',
                        cnic: widget.cnic ?? '',
                        email: widget.email ?? '',
                        phone: widget.phone ?? '',
                        password: widget.password ?? '',
                        position: widget.category ?? '',
                        dateOfBirth: widget.dateOfBirth ?? {
                          'Day':  1,
                          'Month': 1,
                          'Year': 2025
                        },
                        gender: widget.gender ?? '',
                        permanentAddress: widget.permanentAddress ?? '',
                        currentAddress: widget.currentAddress ?? '').then((_) {
                          Utilities().successMsg('Account Created Successfully');
                    });

                  }
                  else {
                    _authService.signInWithOTP(otpViewModel.otpController.text, widget.verificationId).then((value) {
                      loadingViewModel.setLoading(false);
                      if(value == '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                      else {
                        Utilities().errorMsg(value);
                      }
                    });
                  }
                }

              },
            ),
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
