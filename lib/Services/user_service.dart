import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex_clock/ViewModels/Summary_ViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../Models/Attendance_Moldel.dart';

class UserService {

  Future<Map<String, dynamic>?> fetchCurrentUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        DocumentSnapshot<Map<String, dynamic>> userDocument = await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .get();


        if (userDocument.exists) {
          Map<String, dynamic> userData = userDocument.data() ?? {};

          return userData;
        } else {
        }
      } else {
      }
    } catch (e) {
      throw Exception("Failed to fetch current user data");
    }
    return null;
  }

  Future<String> isConnectedToCompanyWiFi() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();

    return wifiIP!;
  }

  Future<Map<String, dynamic>> markAttendance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {"msg": "User not signed in", "status": false};

    final now = DateTime.now();
    final userId = user.uid;
    final formattedDate = DateFormat('dd-MM-yyyy').format(now);

    final attendanceDoc = FirebaseFirestore.instance
        .collection('Attendance')
        .doc(userId)
        .collection('records')
        .doc(formattedDate);

    final snapshot = await attendanceDoc.get();

    if (!snapshot.exists) {
      // User is checking in
      await attendanceDoc.set({
        'checkIn': FieldValue.serverTimestamp(),
        'status': 'present',
      });
      return {
        "msg": "Check-in successful.",
        "status": true
      };
    } else if (!snapshot.data()!.containsKey('checkOut')) {
      // User is checking out
      final checkInTimestamp = snapshot.data()!['checkIn'] as Timestamp?;
      if (checkInTimestamp == null) {
        return {
          "msg": "Check-in time not found.",
          "status": false
        };
      }

      final checkInTime = checkInTimestamp.toDate();
      final checkOutTime = DateTime.now(); // Local time (optionally, use server time if needed)

      final workedDuration = checkOutTime.difference(checkInTime);
      final workedHours = workedDuration.inHours;
      final workedMinutes = workedDuration.inMinutes % 60;

      final formattedDuration = "${workedHours.toString().padLeft(2, '0')}:${workedMinutes.toString().padLeft(2, '0')}";

      await attendanceDoc.update({
        'checkOut': FieldValue.serverTimestamp(),
        'workedDuration': formattedDuration, // Store as "HH:mm"
      });

      return {
        "msg": "Check-out successful. Total time worked: $formattedDuration.",
        "status": true
      };
    } else {
      return {
        "msg": "You have already checked out today.",
        "status": false
      };
    }
  }

  Future<void> applyLeave(String reason, DateTime selectedLeaveDate, String leaveType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return ;

    final userId = user.uid;

    FirebaseFirestore.instance
        .collection('Leave')
        .doc(userId)
        .collection('leaveRecords')
        .add({
      'appliedAt': Timestamp.now(),
      'leaveDate': Timestamp.fromDate(selectedLeaveDate),
      'leaveType': leaveType,
      'reason': reason,
      'status': 'pending',
    });


  }

  Future<void> applyCorrectionRequest(String reason, Map<String, dynamic> date, Map<String, dynamic> checkIn, Map<String, dynamic> checkOut) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return ;

    final userId = user.uid;

    FirebaseFirestore.instance
        .collection('Correction')
        .doc(userId)
        .collection('correctionRecords')
        .add({
      'appliedAt': Timestamp.now(),
      'correction_date': date,
      'correction_checkIn': checkIn,
      'correction_checkOut': checkOut,
      'reason': reason,
      'status': 'pending',
    });


  }

  Future<void> loadAttendanceRecords(SummaryViewModel model) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final now = DateTime.now();
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);

    final snapshot = await FirebaseFirestore.instance
        .collection("Attendance")
        .doc(userId)
        .collection("records")
        .where("checkIn", isGreaterThanOrEqualTo: Timestamp.fromDate(oneYearAgo))
        .where("checkIn", isLessThanOrEqualTo: Timestamp.fromDate(now))
        .get();

    final Map<String, bool> tempRecords = {};
    final List<WorkedEntry> tempDurations = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final status = data['status'];
      final workedStr = data['workedDuration'];
      final checkIn = data['checkIn'] as Timestamp?;

      if (status != null) {
        tempRecords[doc.id] = status == "present";
      }

      if (workedStr != null && checkIn != null) {
        final checkInDate = DateTime(checkIn.toDate().year, checkIn.toDate().month, checkIn.toDate().day);
        final parts = workedStr.split(':');
        if (parts.length == 2) {
          final hours = int.tryParse(parts[0]) ?? 0;
          final minutes = int.tryParse(parts[1]) ?? 0;
          tempDurations.add(WorkedEntry(checkInDate, Duration(hours: hours, minutes: minutes)));
        }
      }
    }

    model.setAttendanceRecords(tempRecords);
    model.setAllWorkedDurations(tempDurations);
  }

  Future<List<AttendanceModel>> fetchAttendanceForMonth({
    required int month,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    int year = DateTime.now().year;
    List<AttendanceModel> monthlyData = [];

    final DateFormat docIdFormat = DateFormat('dd-MM-yyyy');
    final DateFormat displayFormat = DateFormat('dd MMM');

    // Start and end of selected month
    DateTime firstDay = DateTime(year, month, 1);
    DateTime lastDay = DateTime(year, month + 1, 0);

    for (int day = 0; day <= lastDay.day - 1; day++) {
      DateTime currentDate = firstDay.add(Duration(days: day));
      String docId = docIdFormat.format(currentDate);
      String displayDate = displayFormat.format(currentDate);

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Attendance')
          .doc(userId)
          .collection('records')
          .doc(docId)
          .get();

      if (snapshot.exists) {
        Timestamp? checkInTimestamp = snapshot['checkIn'];
        Timestamp? checkOutTimestamp = snapshot['checkOut'];

        DateTime checkInTime = checkInTimestamp!.toDate();
        DateTime checkOutTime = checkOutTimestamp!.toDate();

        Duration duration = checkOutTime.difference(checkInTime);
        int hours = duration.inHours;
        int minutes = duration.inMinutes.remainder(60);

        String formattedHours = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

        String status = 'Full Day';
        if (hours < 8) {
          status = 'Early Leave';
        }

        monthlyData.add(
          AttendanceModel(
            date: displayDate,
            checkIn: DateFormat('hh:mm a').format(checkInTime),
            checkOut: DateFormat('hh:mm a').format(checkOutTime),
            hours: formattedHours,
            status: status,
          ),
        );
      } else {
        monthlyData.add(
          AttendanceModel(
            date: displayDate,
            checkIn: '--:--',
            checkOut: '--:--',
            hours: '--:--',
            status: 'Absent',
          ),
        );
      }
    }

    return monthlyData;
  }


}