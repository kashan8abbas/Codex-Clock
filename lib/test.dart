import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class RandomAttendanceScreen extends StatelessWidget {
  const RandomAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insert Random Attendance')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await insertRandomAttendance();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Random attendance inserted!")),
            );
          },
          child: const Text("Insert Random Record"),
        ),
      ),
    );
  }

  Future<void> insertRandomAttendance() async {
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Generate random check-in and check-out times
    final now = DateTime.now();
    final random = Random();

    final int checkInHour = 6 + random.nextInt(3); // 6AM to 8AM
    final int workDuration = 6 + random.nextInt(4); // 6 to 9 hours

    final checkIn = DateTime(now.year, now.month, now.day, checkInHour, random.nextInt(60));
    final checkOut = checkIn.add(Duration(hours: workDuration, minutes: random.nextInt(60)));

    final Duration worked = checkOut.difference(checkIn);
    final String workedDuration = _formatDuration(worked);

    await firestore
        .collection("Attendance")
        .doc(userId)
        .collection("records")
        .doc('29-09-2025') // doc name = timestamp string
        .set({
      "checkIn": Timestamp.fromDate(checkIn),
      "checkOut": Timestamp.fromDate(checkOut),
      "workedDuration": workedDuration,
      "status": "present",
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    return "$hours:$minutes";
  }
}