import 'package:codex_clock/Services/auth_service.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/ViewModels/Register2_VIewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/OTPVerificationScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomDropdown.dart';
import 'package:codex_clock/Views/Widgets/CustomLabel.dart';
import 'package:codex_clock/Views/Widgets/CustomRadio.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TakePhotoScreen.dart';

class Registration2Screen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String cnic;
  final String email;
  final String phoneVerification;
  final String phone;
  final String password;

  Registration2Screen({super.key,
    required this.firstName,
    required this.lastName,
    required this.cnic,
    required this.email,
    required this.phoneVerification,
    required this.phone,
    required this.password
  });

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);
    final loadingViewModel = Provider.of<LoadingViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    SizedBox(height: 1,)
                  ],
                ),
              ),
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
              const SizedBox(height: 15),
              CustomDropdown(
                label: "Select Your",
                items: ["Option 1", "Option 2"],
                selectedValue: viewModel.selectedCategory,
                onChanged: viewModel.setCategory,
              ),
              const SizedBox(height: 15),

              const CustomLabel(text: "Date of Birth"),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      label: "Day",
                      items: List.generate(
                        31,
                        (index) => (index + 1).toString(),
                      ),
                      selectedValue: viewModel.selectedDay,
                      onChanged:
                          (value) {
                            viewModel.setDateOfBirth(
                              value!,
                              viewModel.selectedMonth ?? "",
                              viewModel.selectedYear ?? "",
                            );
                      }
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      label: "Month",
                      items: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                      selectedValue: viewModel.selectedMonth,
                      onChanged:
                          (value) => viewModel.setDateOfBirth(
                            viewModel.selectedDay ?? "",
                            value!,
                            viewModel.selectedYear ?? "",
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      label: "Year",
                      items: List.generate(
                        50,
                        (index) => (2025 - index).toString(),
                      ),
                      selectedValue: viewModel.selectedYear,
                      onChanged:
                          (value) {
                            viewModel.setDateOfBirth(
                              viewModel.selectedDay ?? "",
                              viewModel.selectedMonth ?? "",
                              value!,
                            );
                      }
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CustomLabel(text: "Gender"),
              Customradio(
                genderList: ["Male", "Female"],
                onGenderSelected: viewModel.setGender,
              ),
              const SizedBox(height: 15),
              const CustomLabel(text: "Enter Your Permanent Address"),
              CustomTextField(
                hint: "Permanent Address",
                controller: viewModel.permanentAddressController,
                focusNode: viewModel.permanentAddressFocusNode,
              ),
              const SizedBox(height: 15),
              const CustomLabel(text: "Enter Your Current Address"),
              CustomTextField(
                hint: "Current Address",
                controller: viewModel.currentAddressController,
                focusNode: viewModel.currentAddressFocusNode,
              ),
              const SizedBox(height: 15),

              CustomButton(
                color: Color.fromRGBO(236, 0, 60, 1),
                text: "Sign Up",
                onPressed: () {
                  if (viewModel.validateForm()) {
                    loadingViewModel.setLoading(true);
                    _authService.verifyPhoneNumber(phoneVerification).then((value) {
                      loadingViewModel.setLoading(false);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          OtpVerificationScreen(
                            isSignUp: true,
                            phoneNo: phoneVerification,
                            verificationId: value,
                              firstName: firstName,
                              lastName: lastName,
                              cnic: cnic,
                              email: email,
                              phone: phone,
                              password: password,
                              category: viewModel.selectedCategory ?? '',
                              dateOfBirth: {
                                'Day': viewModel.selectedDay ?? '1',
                                'Month': viewModel.selectedMonth ?? 'Jan',
                                'Year': viewModel.selectedYear ?? '2025'
                              },
                              gender: viewModel.selectedGender,
                              permanentAddress: viewModel.permanentAddressController.text.trim(),
                              currentAddress: viewModel.currentAddressController.text.trim()
                          )
                      ));
                    });

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
