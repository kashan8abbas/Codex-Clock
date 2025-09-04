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
  final String firstName;
  final String lastName;
  final String cnic;
  final String email;
  final String phone;
  final String password;

  Registration2Screen({super.key,
    required this.firstName,
    required this.lastName,
    required this.cnic,
    required this.email,
    required this.phone,
    required this.password
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
              const CustomLabel(text: "Select Your Designation"),
              SizedBox(height: 5,),
              CustomDropdown(
                items: ["CEO", "COO", "CTO", "HR",
                  "Flutter Team Lead", "Senior Flutter Developer",
                  "Junior Flutter Developer", "Shopify Team Lead", "Senior Shopify Developer",
                  "Junior Shopify Developer", "Wordpress Team Lead", "Senior Wordpress Developer",
                  "Junior Wordpress Developer", "Graphic Team Lead", "Senior Graphic Designer",
                  "Junior Graphic Designer", "UI/UX Designer", "Senior UI/UX Designer",
                  "Junior UI/UX Designer", "AI/ML"],
                selectedValue: viewModel.selectedCategory,
                onChanged: viewModel.setCategory,
                text: Text('Select Designation', style: TextStyle(color: Colors.grey, fontSize: 14),),
                errorText: viewModel.categoryError,
              ),

              const SizedBox(height: 15),
              const CustomLabel(text: "Date of Birth"),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      items: List.generate(
                        31,
                        (index) => (index + 1).toString(),
                      ),
                      selectedValue: viewModel.selectedDayDOB,
                      onChanged:
                          (value) {
                            viewModel.setDateOfBirth(
                              value!,
                              viewModel.selectedMonthDOB ?? "",
                              viewModel.selectedYearDOB ?? "",
                            );
                      },
                      text: Text('Day', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      errorText: viewModel.dayDOBError,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      items: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                      selectedValue: viewModel.selectedMonthDOB,
                      onChanged:
                          (value) => viewModel.setDateOfBirth(
                            viewModel.selectedDayDOB ?? "",
                            value!,
                            viewModel.selectedYearDOB ?? "",
                          ),
                      text: Text('Month', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      errorText: viewModel.monthDOBError,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      items: List.generate(
                        50,
                        (index) => (2025 - index).toString(),
                      ),
                      selectedValue: viewModel.selectedYearDOB,
                      onChanged:
                          (value) {
                            viewModel.setDateOfBirth(
                              viewModel.selectedDayDOB ?? "",
                              viewModel.selectedMonthDOB ?? "",
                              value!,
                            );
                      },
                      text: Text('Year', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      errorText: viewModel.yearDOBError,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              CustomLabel(text: "Gender"),
              SizedBox(height: 5,),
              Customradio(
                genderList: ["Male", "Female"],
                selectedGender: viewModel.selectedGender,
                onGenderSelected: viewModel.setGender,
                errorText: viewModel.genderError,
              ),

              const SizedBox(height: 15),
              const CustomLabel(text: "Enter Your Permanent Address"),
              CustomTextField(
                hint: "Permanent address",
                controller: viewModel.permanentController,
                focusNode: viewModel.permanentFocusNode,
                errorText: viewModel.permanentError,
              ),

              const SizedBox(height: 15),
              const CustomLabel(text: "Enter Your Current Address"),
              CustomTextField(
                hint: "Current address",
                controller: viewModel.currentController,
                focusNode: viewModel.currentFocusNode,
                errorText: viewModel.currentError,
              ),

              const SizedBox(height: 15),
              const CustomLabel(text: "Joining Date"),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      items: List.generate(
                        31,
                            (index) => (index + 1).toString(),
                      ),
                      selectedValue: viewModel.selectedDayJD,
                      onChanged:
                          (value) {
                        viewModel.setDateOfJoining(
                          value!,
                          viewModel.selectedMonthJD ?? "",
                          viewModel.selectedYearJD ?? "",
                        );
                      },
                      text: Text('Day', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      errorText: viewModel.dayJDError,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      items: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                      selectedValue: viewModel.selectedMonthJD,
                      onChanged:
                          (value) => viewModel.setDateOfJoining(
                        viewModel.selectedDayJD ?? "",
                        value!,
                        viewModel.selectedYearJD ?? "",
                      ),
                      text: Text('Month', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      errorText: viewModel.monthJDError,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      items: List.generate(
                        50,
                            (index) => (2025 - index).toString(),
                      ),
                      selectedValue: viewModel.selectedYearJD,
                      onChanged:
                          (value) {
                        viewModel.setDateOfJoining(
                          viewModel.selectedDayJD ?? "",
                          viewModel.selectedMonthJD ?? "",
                          value!,
                        );
                      },
                      text: Text('Year', style: TextStyle(color: Colors.grey, fontSize: 14),),
                      errorText: viewModel.yearJDError,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              CustomButton(
                color: Color.fromRGBO(236, 0, 60, 1),
                text: "Sign Up",
                onPressed: () {
                  if(cameraViewModel.selectedImage != null) {
                    if (viewModel.validateForm()) {
                      loadingViewModel.setLoading(true);
                      _authService.signUpService(
                          firstName: firstName,
                          lastName: lastName,
                          cnic: cnic,
                          phone: phone,
                          email: email,
                          password: password,
                          position: viewModel.selectedCategory!,
                          dateOfBirth: {
                            'day': viewModel.selectedDayDOB,
                            'month': viewModel.selectedMonthDOB,
                            'year': viewModel.selectedYearDOB
                          },
                          gender: viewModel.selectedGender,
                          permanentAddress: viewModel.permanentController.text.trim(),
                          currentAddress: viewModel.currentController.text.trim(),
                          dateOfJoining: {
                            'day': viewModel.selectedDayJD,
                            'month': viewModel.selectedMonthJD,
                            'year': viewModel.selectedYearJD
                          },
                        imageFile: cameraViewModel.selectedImage!
                      ).then((value) {
                        _userService.fetchCurrentUserData().then((userData) {
                          if(userData != null) {
                            userDataViewModel.updateUserData(
                                userData["Uid"],
                                userData["firstName"],
                                userData["lastName"],
                                userData["cnic"],
                                userData["phone"],
                                userData["email"],
                                userData["position"],
                                userData["dateOfBirth"],
                                userData["gender"],
                                userData["permanentAddress"],
                                userData["currentAddress"],
                                userData["dateOfJoining"],
                                userData["profilePic"],
                                userData["createdAt"],
                                userData["status"]
                            );
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
                  }
                  else {
                    Utilities().errorMsg('Please Select an Image');
                  }
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
