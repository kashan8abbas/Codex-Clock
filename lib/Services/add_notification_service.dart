import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationService {
  final CollectionReference _notifications =
  FirebaseFirestore.instance.collection('adminNotifications');

  Future<void> addNotification({
    required String title,
    required String description,
    required String userName,
    required String userImage,
    required String userId,
  }) async {
    try {
      await _notifications.add({
        'title': title,
        'description': description,
        'userName': userName,
        'userImage': userImage,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'isSeen': false,
      });
    } catch (e) {
      throw Exception("Failed to add notification: $e");
    }
  }
}
