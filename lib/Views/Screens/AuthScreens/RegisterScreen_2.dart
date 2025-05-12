import 'package:codex_clock/Services/auth_service.dart';
import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/ViewModels/Register2_VIewModel.dart';
import 'package:codex_clock/ViewModels/TakePhoto_ViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/OTPVerificationScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomDropdown.dart';
import 'package:codex_clock/Views/Widgets/CustomLabel.dart';
import 'package:codex_clock/Views/Widgets/CustomRadio.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HomePages/HomeScreen.dart';
import 'TakePhotoScreen.dart';

class Registration2Screen extends StatelessWidget {
  final String uid;
  final String firstName;
  final String lastName;
  final String cnic;
  final String permanentAddress;
  final String currentAddress;
  final String phone;

  Registration2Screen({super.key,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.cnic,
    required this.permanentAddress,
    required this.currentAddress,
    required this.phone
  });

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);
    final loadingViewModel = Provider.of<LoadingViewModel>(context, listen: true);
    final cameraViewModel = Provider.of<CameraViewModel>(context, listen: true);
    final userDataViewModel = Provider.of<UserDataViewModel>(context, listen: true);

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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(),
                          ),
                        );
                        // If you plan to return the selected image from CameraScreen, handle it here
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromRGBO(236, 0, 60, 1),
                            width: 2.5,
                          ),
                        ),
                        child: cameraViewModel.selectedImage == null
                            ? const Center(
                          child: Text(
                            "Upload Photo",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                            : ClipOval(
                          child: Image.file(
                            cameraViewModel.selectedImage!,
                            fit: BoxFit.cover,
                            width: 130,
                            height: 130,
                          ),
                        ),
                      ),
                    ),

                    cameraViewModel.selectedImage == null ? Positioned(
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
                    ) : SizedBox(),
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
              CustomButton(
                color: Color.fromRGBO(236, 0, 60, 1),
                text: "Sign Up",
                onPressed: () {
                  if (viewModel.validateForm()) {
                    loadingViewModel.setLoading(true);
                    _authService.signUpService(
                      uid: uid,
                      firstName: firstName,
                      lastName: lastName,
                      cnic: cnic,
                      permanentAddress: permanentAddress,
                      currentAddress: currentAddress,
                      dateOfBirth: {
                        'day': viewModel.selectedDay,
                        'month': viewModel.selectedMonth,
                        'year': viewModel.selectedYear
                      },
                      gender: viewModel.selectedGender,
                      phone: phone,
                      position: viewModel.selectedCategory!
                    ).then((value) {
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
                              userData["position"]);
                          loadingViewModel.setLoading(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                        else{
                          loadingViewModel.setLoading(false);
                          Utilities().errorMsg('Error Fetching User Data');
                        }

                      });


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
