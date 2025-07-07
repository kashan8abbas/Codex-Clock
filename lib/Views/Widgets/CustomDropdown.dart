import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final Widget text;
  final String? errorText;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    this.onChanged,
    required this.text,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          hint: text,

          value:
              (selectedValue != null && items.contains(selectedValue))
                  ? selectedValue
                  : null, // Ensure the selected value exists in items
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromRGBO(236, 0, 60, 1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromRGBO(236, 0, 60, 1), width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item), );
              }).toList(),
          onChanged: onChanged,
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
