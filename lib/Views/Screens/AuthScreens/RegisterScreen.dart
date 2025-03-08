import 'package:codex_clock/Views/Screens/AuthScreens/TakePhotoScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codex_clock/ViewModels/Register_ViewModel.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomLabel.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationViewModel(),
      child: Consumer<RegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Upload Section
                  Center(
                    child: Stack(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromRGBO(236, 0, 60, 1),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Upload Photo",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 25,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 14,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Fields
                  const CustomLabel(text: "Enter Your Name"),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "First Name",
                          controller: viewModel.firstNameController,
                          errorText: viewModel.firstNameError,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField(
                          hint: "Last Name",
                          controller: viewModel.lastNameController,
                          errorText: viewModel.lastNameError,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const CustomLabel(text: "Enter C.N.I.C No"),
                  CustomTextField(
                    hint: "C.N.I.C No",
                    controller: viewModel.cnicController,
                    errorText: viewModel.cnicError,
                  ),

                  const SizedBox(height: 16),
                  const CustomLabel(text: "Enter Your Email"),
                  CustomTextField(
                    hint: "Email",
                    controller: viewModel.emailController,
                    errorText: viewModel.emailError,
                  ),

                  const SizedBox(height: 16),
                  const CustomLabel(text: "Enter Your Mobile No"),
                  CustomTextField(
                    hint: "Mobile No",
                    controller: viewModel.mobileController,
                    errorText: viewModel.mobileError,
                  ),

                  const SizedBox(height: 16),
                  const CustomLabel(text: "Enter Your Password"),
                  CustomTextField(
                    hint: "Password",
                    controller: viewModel.passwordController,
                    obscureText: true,
                    errorText: viewModel.passwordError,
                  ),

                  const SizedBox(height: 34),

                  // Next Button
                  CustomButton(
                    text: "Next",
                    color: const Color.fromRGBO(236, 0, 60, 1),
                    onPressed: () {
                      if (viewModel.validateForm()) {
                        // Proceed to next screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Form is valid, proceeding..."),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
