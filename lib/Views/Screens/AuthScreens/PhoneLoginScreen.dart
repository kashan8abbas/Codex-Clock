import 'package:codex_clock/Services/auth_service.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/ViewModels/PhoneLogin_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/OTPVerificationScreen.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/RegisterScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../Services/internet_connectivity.dart';

class PhoneLoginScreen extends StatefulWidget {


  PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    ConnectivityHelper.listenToConnectivityChanges(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhoneLoginViewModel(),
      child: Consumer2<PhoneLoginViewModel, LoadingViewModel>(
        builder: (context, viewModel, loadingViewModel, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                SvgPicture.asset(
                  "lib/Utils/Images/Logo.svg",
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter your mobile number",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: "Enter Number",
                        controller: viewModel.phoneController,
                        focusNode: viewModel.phoneFocusNode,
                        isPhoneField: true,
                        errorText: viewModel.errorText,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: "Login",
                        color: const Color.fromRGBO(236, 0, 60, 1),
                        onPressed: () {
                          viewModel.validatePhoneNumber();
                          if (viewModel.errorText == null) {
                            loadingViewModel.setLoading(true);
                            _authService.verifyPhoneNumber("+92${viewModel.phoneController.text}").then((value) {
                              loadingViewModel.setLoading(false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpVerificationScreen(phoneNo: viewModel.phoneController.text, verificationId: value),
                                ),
                              );
                            });
                          }
                        },
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 1,)
              ],
            ),
          );
        },
      ),
    );
  }
}
