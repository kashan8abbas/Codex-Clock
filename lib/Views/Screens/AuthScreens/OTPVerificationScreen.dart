import 'package:codex_clock/Services/auth_service.dart';
import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/RegisterScreen.dart';
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

  const OtpVerificationScreen({super.key,
    required this.phoneNo,
    required this.verificationId,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final OtpViewModel otpViewModel = OtpViewModel(); // Initialize ViewModel

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

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
    final userDataViewModel = Provider.of<UserDataViewModel>(context, listen: true);
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
                  _authService.signInWithOTP(otpViewModel.otpController.text, widget.verificationId).then((value) {
                    if(value['status'] == 'success') {
                      _userService.fetchCurrentUserData().then((userData) {
                        if(userData != null) {
                          userDataViewModel.updateUserData(
                              userData["Uid"],
                              userData["cnic"],
                              userData["currentAddress"],
                              userData["dateOfBirth"],
                              userData["email"] ?? '',
                              userData["firstName"],
                              userData["gender"],
                              userData["lastName"],
                              userData["permanentAddress"],
                              userData["phone"],
                              userData["position"],
                              userData["profilePic"],
                              userData["createdAt"]
                          );
                          loadingViewModel.setLoading(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                        else {
                          loadingViewModel.setLoading(false);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen(uid: value['uid'], phone: widget.phoneNo,)));
                        }
                      });
                    }
                    else {
                      loadingViewModel.setLoading(false);
                      Utilities().errorMsg(value['error']);
                    }
                  });
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
