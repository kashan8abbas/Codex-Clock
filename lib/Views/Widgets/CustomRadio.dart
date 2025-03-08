import 'package:flutter/material.dart';

class Customradio extends StatefulWidget {
  final Function(String) onGenderSelected;
  final List<String> genderList;

  const Customradio({
    super.key,
    required this.onGenderSelected,
    required this.genderList,
  });

  @override
  _CustomradioState createState() => _CustomradioState();
}

class _CustomradioState extends State<Customradio> {
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.genderList.first;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.genderList.length * 2 - 1, (index) {
        if (index.isEven) {
          bool isSelected = selectedGender == widget.genderList[index ~/ 2];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedGender = widget.genderList[index ~/ 2];
                });
                widget.onGenderSelected(widget.genderList[index ~/ 2]);
              },
              child: Container(
                height: screenHeight / 17,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(236, 0, 60, 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.transparent,
                    width: isSelected ? 2 : 0,
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
                      widget.genderList[index ~/ 2],
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
                      color:
                          isSelected
                              ? Color.fromRGBO(236, 0, 60, 1)
                              : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox(width: 20); // Adjust spacing here
        }
      }),
    );
  }
}
