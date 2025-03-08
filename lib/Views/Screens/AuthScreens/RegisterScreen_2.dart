import 'package:codex_clock/ViewModels/Register2_VIewModel.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/CustomDropdown.dart';
import 'package:codex_clock/Views/Widgets/CustomLabel.dart';
import 'package:codex_clock/Views/Widgets/CustomRadio.dart';
import 'package:codex_clock/Views/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registration2Screen extends StatelessWidget {
  const Registration2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                          (value) => viewModel.setDateOfBirth(
                            value!,
                            viewModel.selectedMonth ?? "",
                            viewModel.selectedYear ?? "",
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomDropdown(
                      label: "Month",
                      items: ["Jan", "Feb", "Mar", "Apr", "May"],
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
                          (value) => viewModel.setDateOfBirth(
                            viewModel.selectedDay ?? "",
                            viewModel.selectedMonth ?? "",
                            value!,
                          ),
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
              const CustomLabel(text: "Enter Your Parmenant Address"),
              CustomTextField(
                hint: "Permanent Address",
                controller: viewModel.permanentAddressController,
              ),
              const SizedBox(height: 15),
              const CustomLabel(text: "Enter Your Current Address"),
              CustomTextField(
                hint: "Current Address",
                controller: viewModel.currentAddressController,
              ),
              const SizedBox(height: 30),

              CustomButton(
                color: Color.fromRGBO(236, 0, 60, 1),
                text: "Sign Up",
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
      ),
    );
  }
}
