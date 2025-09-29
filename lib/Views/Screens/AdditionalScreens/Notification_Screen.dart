import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final CollectionReference _notifications =
  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Notifications');

  @override
  void initState() {
    super.initState();
    _markAllAsSeen();
  }

  Future<void> _markAllAsSeen() async {
    try {
      final snapshot =
      await _notifications.where('isSeen', isEqualTo: false).get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'isSeen': true});
      }
    } catch (e) {
      debugPrint("Error updating notifications: $e");
    }
  }

  String formatNotificationTime(Timestamp? timestamp) {
    if (timestamp == null) return "";

    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    // Remove hours/minutes/seconds for date comparison
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.isAfter(today)) {
      // Today
      return "Today, ${DateFormat('h:mm a').format(dateTime)}";
    } else if (dateTime.isAfter(yesterday)) {
      // Yesterday
      return "Yesterday, ${DateFormat('h:mm a').format(dateTime)}";
    } else {
      // Older
      return DateFormat('dd-MMM-yyyy, h:mm a').format(dateTime);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notifications
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: data['userImage'] != null &&
                      data['userImage'].toString().isNotEmpty
                      ? NetworkImage(data['userImage'])
                      : null,
                  child: data['userImage'] == null ||
                      data['userImage'].toString().isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['description'] ?? ''),
                trailing: Text(
                  formatNotificationTime(data['createdAt']),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

              );
            },
          );
        },
      ),
    );
  }
}
