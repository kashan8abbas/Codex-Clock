import 'dart:io';

import 'package:codex_clock/Utils/Utilities.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/TakePhotoScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codex_clock/ViewModels/Register_ViewModel.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomLabel.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';

import '../../../ViewModels/TakePhoto_ViewModel.dart';
import 'RegisterScreen_2.dart';

class RegistrationScreen extends StatelessWidget {
  final String uid;
  final String phone;
  const RegistrationScreen({super.key, required this.uid, required this.phone});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationViewModel(),
      child: Consumer2<RegistrationViewModel, CameraViewModel>(
        builder: (context, viewModel, cameraViewModel, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  const SizedBox(height: 24),

                  // Name Fields
                  const CustomLabel(text: "Enter Your Name"),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "First Name",
                          controller: viewModel.firstNameController,
                          focusNode: viewModel.firstNameFocusNode,
                          errorText: viewModel.firstNameError,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField(
                          hint: "Last Name",
                          controller: viewModel.lastNameController,
                          focusNode: viewModel.lastNameFocusNode,
                          errorText: viewModel.lastNameError,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const CustomLabel(text: "Enter C.N.I.C No"),
                  CustomTextField(
                    hint: "XXXXX-XXXXXXX-X",
                    controller: viewModel.cnicController,
                    focusNode: viewModel.cnicFocusNode,
                    isCnic: true,
                    errorText: viewModel.cnicError,
                  ),

                  const SizedBox(height: 15),
                  const CustomLabel(text: "Enter Your Permanent Address"),
                  CustomTextField(
                    hint: "Permanent Address",
                    controller: viewModel.permanentAddressController,
                    focusNode: viewModel.permanentAddressFocusNode,
                    errorText: viewModel.permanentError,
                  ),

                  const SizedBox(height: 15),
                  const CustomLabel(text: "Enter Your Current Address"),
                  CustomTextField(
                    hint: "Current Address",
                    controller: viewModel.currentAddressController,
                    focusNode: viewModel.currentAddressFocusNode,
                    errorText: viewModel.currentError,
                  ),


                  const SizedBox(height: 34),

                  // Next Button
                  CustomButton(
                    text: "Next",
                    color: const Color.fromRGBO(236, 0, 60, 1),
                    onPressed: () {
                      if(cameraViewModel.selectedImage != null) {
                        if (viewModel.validateForm()) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              Registration2Screen(
                                uid: uid,
                                firstName: viewModel.firstNameController.text.trim(),
                                lastName: viewModel.lastNameController.text.trim(),
                                cnic: viewModel.cnicController.text.trim(),
                                permanentAddress: viewModel.permanentAddressController.text.trim(),
                                currentAddress: viewModel.currentAddressController.text.trim(),
                                phone: phone,

                              )
                          ));
                        }
                      }
                      else {
                        Utilities().errorMsg('Please Select an Image');
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
