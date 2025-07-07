import 'package:flutter/material.dart';

class Customradio extends StatelessWidget {
  final String selectedGender;
  final List<String> genderList;
  final Function(String) onGenderSelected;
  final String? errorText;

  const Customradio({
    super.key,
    required this.genderList,
    required this.selectedGender,
    required this.onGenderSelected,
    this.errorText
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(genderList.length * 2 - 1, (index) {
            if (index.isEven) {
              final gender = genderList[index ~/ 2];
              final isSelected = selectedGender == gender;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onGenderSelected(gender),
                  child: Container(
                    height: screenHeight / 17,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromRGBO(236, 0, 60, 1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          gender,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: const Color.fromRGBO(236, 0, 60, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox(width: 20);
            }
          }),
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
