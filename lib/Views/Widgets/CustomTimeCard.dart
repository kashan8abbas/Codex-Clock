import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TimeCardWidget extends StatefulWidget {
  @override
  _TimeCardWidgetState createState() => _TimeCardWidgetState();
}

class _TimeCardWidgetState extends State<TimeCardWidget> {
  String currentTime = "";
  String currentDate = "";

  @override
  void initState() {
    super.initState();
    updateTime();
  }

  void updateTime() {
    currentTime = DateFormat('hh:mm a').format(DateTime.now()); // Initial time
    currentDate = DateFormat(
      'MMM dd - yyyy EEEE',
    ).format(DateTime.now()); // Initial date

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateFormat('hh:mm a').format(DateTime.now());
          currentDate = DateFormat('MMM dd - yyyy EEEE').format(DateTime.now());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimeCard();
  }

  Widget _buildTimeCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8, // Adds a default shadow effect
      shadowColor: Colors.black.withOpacity(0.7), // Customize shadow color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentTime, // Dynamic Current Time
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              currentDate, // Dynamic Current Date
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _IconText(icon: Icons.access_time, text: "10:00 AM\nCheck In"),
                _IconText(icon: Icons.logout, text: "06:00 PM\nCheck Out"),
                _IconText(icon: Icons.timer, text: "08:00\nTotal Hrs"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.black54),
        const SizedBox(height: 5),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
