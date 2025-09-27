import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../ViewModels/CompanyData_ViewModel.dart';

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

  String calculateWorkingHours(String checkIn, String checkOut) {
    // Convert the time strings to DateTime objects
    final DateFormat timeFormat = DateFormat('hh:mm a');
    DateTime checkInTime = timeFormat.parse(checkIn);
    DateTime checkOutTime = timeFormat.parse(checkOut);

    // If checkout time is before check-in time (i.e., it's on the next day), adjust for that
    if (checkOutTime.isBefore(checkInTime)) {
      checkOutTime = checkOutTime.add(Duration(days: 1));
    }

    // Calculate the difference between checkIn and checkOut
    Duration difference = checkOutTime.difference(checkInTime);

    // Format the result as "HH:mm"
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;

    // Ensure the format is "HH:mm"
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimeCard();
  }

  Widget _buildTimeCard() {
    final viewModel = Provider.of<CompanyDataViewModel>(context, listen: true);
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8, // Adds a default shadow effect
      shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _IconText(icon: Icons.access_time, text: viewModel.timingFrom['hour'] != null ? "${viewModel.timingFrom['hour']}:${viewModel.timingFrom['mint']} ${viewModel.timingFrom['period']}" : ''),
                _IconText(icon: Icons.logout, text: viewModel.timingTo['hour'] != null ? "${viewModel.timingTo['hour']}:${viewModel.timingTo['mint']} ${viewModel.timingTo['period']}" : ''),
                _IconText(icon: Icons.timer, text: viewModel.timingFrom['hour'] != null && viewModel.timingTo['hour'] != null ? calculateWorkingHours("${viewModel.timingFrom['hour']}:${viewModel.timingFrom['mint']} ${viewModel.timingFrom['period']}", "${viewModel.timingTo['hour']}:${viewModel.timingTo['mint']} ${viewModel.timingTo['period']}") : ''),
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
        Icon(icon, size: 30, color: Colors.black),
        const SizedBox(height: 5),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
