import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';

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
      await attendanceDoc.set({
        'checkIn': FieldValue.serverTimestamp(),
        'status': 'present',
      });
      return {
        "msg": "Check-in successful.",
        "status": true
      };
    } else if (!snapshot.data()!.containsKey('checkOut')) {
      await attendanceDoc.update({
        'checkOut': FieldValue.serverTimestamp(),
      });
      return {
        "msg": "Check-out successful.",
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
        .collection('records')
        .add({
      'appliedAt': Timestamp.now(),
      'leaveDate': Timestamp.fromDate(selectedLeaveDate),
      'leaveType': leaveType,
      'reason': reason,
      'status': 'pending',
    });


  }


}