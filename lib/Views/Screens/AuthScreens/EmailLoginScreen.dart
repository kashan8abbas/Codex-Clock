import 'package:codex_clock/Services/auth_service.dart';
import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/ViewModels/PhoneLogin_ViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/OTPVerificationScreen.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/PhoneLoginScreen.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/RegisterScreen.dart';
import 'package:codex_clock/Views/Screens/HomePages/HomeScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../ViewModels/EmailLogin_ViewModel.dart';

class EmailLoginScreen extends StatelessWidget {

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmailLoginViewModel(),
      child: Consumer3<EmailLoginViewModel, LoadingViewModel, UserDataViewModel>(
        builder: (context, viewModel, loadingViewModel, userDataViewModel, child) {
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
                        "Enter your Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hint: "Enter Email",
                        controller: viewModel.emailController,
                        focusNode: viewModel.emailFocusNode,
                        errorText: viewModel.emailErrorText,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Enter your Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hint: "Enter Password",
                        controller: viewModel.passwordController,
                        focusNode: viewModel.passwordFocusNode,
                        errorText: viewModel.passwordErrorText,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: "Login",
                        color: const Color.fromRGBO(236, 0, 60, 1),
                        onPressed: () {
                          viewModel.checkEmail();
                          viewModel.checkPassword();
                          if (viewModel.emailErrorText == null && viewModel.passwordErrorText == null) {
                            loadingViewModel.setLoading(true);
                            _authService.signInWithEmail(email: viewModel.emailController.text.trim(), password: viewModel.passwordController.text.trim()).then((value) {
                              _userService.fetchCurrentUserData().then((userData) {
                                if(userData != null) {
                                  print(userData);
                                  userDataViewModel.updateUserData(
                                      userData["Uid"],
                                      userData["cnic"],
                                      userData["currentAddress"],
                                      userData["dateOfBirth"],
                                      userData["email"],
                                      userData["firstName"],
                                      userData["gender"],
                                      userData["lastName"],
                                      userData["permanentAddress"],
                                      userData["phone"],
                                      userData["position"]);
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
                                  Utilities().errorMsg('Error Fetching User Data');
                                }
                              });
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhoneLoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login via Phone No",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(236, 0, 60, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(236, 0, 60, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
