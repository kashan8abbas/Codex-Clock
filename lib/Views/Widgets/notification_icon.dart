import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/AdditionalScreens/Notification_Screen.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Notifications')
          .where('isSeen', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications_outlined, size: 30),
          );
        }

        bool hasUnseen = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
            child: Icon(
              hasUnseen
                  ? Icons.notifications_active_outlined // 🔔 if unseen exists
                  : Icons.notifications_outlined,       // 🔔 simple bell
              size: 30,
            ),
          ),
        );
      },
    );
  }
  
}

