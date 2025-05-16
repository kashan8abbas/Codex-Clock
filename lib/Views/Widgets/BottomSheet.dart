import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:codex_clock/Views/Widgets/LoadingCircularProgressIndicator.dart';
import 'package:flutter/material.dart';

class LeaveBottomSheet extends StatelessWidget {
  final String title;
  final double progressValue;
  final String description;
  final String buttonText;

  const LeaveBottomSheet({
    Key? key,
    required this.title,
    required this.progressValue,
    required this.description,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // Half screen
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color:  Color.fromRGBO(246, 245, 248, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 15),
          CustomCircularIndicator(progressValue: progressValue),
          const SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: buttonText,
            color: const Color.fromRGBO(236, 0, 60, 1),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
