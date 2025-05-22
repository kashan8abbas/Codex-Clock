import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final DateTime checkIn;
  final DateTime checkOut;
  final Duration workedDuration;
  final String status;

  AttendanceModel({
    required this.checkIn,
    required this.checkOut,
    required this.workedDuration,
    required this.status,
  });

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      checkIn: (data['checkIn'] as Timestamp).toDate(),
      checkOut: (data['checkOut'] as Timestamp).toDate(),
      workedDuration: _parseDuration(data['workedDuration']),
      status: data['status'] ?? 'absent',
    );
  }

  static Duration _parseDuration(String durationStr) {
    final parts = durationStr.split(":").map(int.parse).toList();
    return Duration(hours: parts[0], minutes: parts[1]);
  }
}