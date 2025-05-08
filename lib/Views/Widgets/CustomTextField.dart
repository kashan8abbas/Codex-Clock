import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final bool isPhoneField;
  final bool isCnic;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.isPhoneField =
        false, // Default is false, set true for phone number fields
    this.isCnic = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: screenHeight / 17,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
              236,
              0,
              60,
              0.15,
            ), // Light red background
            borderRadius: BorderRadius.circular(10),
            border: errorText != null ? Border.all(color: Colors.red) : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isPhoneField) ...[
                Container(
                  width: 18,
                  height: screenHeight / 16,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text("+92", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  focusNode: focusNode,
                  onTapOutside: (event) => focusNode.unfocus(),
                  keyboardType:
                      isPhoneField ? TextInputType.phone : isCnic ? TextInputType.number : TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
