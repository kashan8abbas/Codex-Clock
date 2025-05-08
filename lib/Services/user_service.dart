import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}