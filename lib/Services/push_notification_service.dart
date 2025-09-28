
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'server_key.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize(BuildContext context) async {
    // Request notification permissions
    requestNotificationPermission();

    // Initialize local notifications
    _initializeLocalNotifications();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((message) {
      if (message.data.isNotEmpty) {
        PushNotificationService.displayNotification(message);
      }
    });


    // Handle notification interactions in the background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationInteraction(context, message);
    });

    // Handle notifications when the app is terminated
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationInteraction(context, initialMessage);
    }
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true ,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (kDebugMode) print('Notification clicked: ${response.payload}');
      },
    );
  }


  static Future<void> displayNotification(RemoteMessage message) async {
    final String title = message.data['title'] ?? 'No Title';
    final String body = message.data['body'] ?? 'No Body';

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
    );
  }


  void _handleNotificationInteraction(
      BuildContext context, RemoteMessage message) {
    if (kDebugMode) print('Notification interaction: ${message.data}');
    if (message.data['type'] == 'chat') {
      // Handle navigation
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatId: message.data['chatId'])));
    }
  }

  void isTokenRefresh(){
    _messaging.onTokenRefresh.listen((event) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      // await updateFcmTokenOnLogin(auth.currentUser!.uid, event);
    });
  }


  Future<void> updateFcmToken(String uid, String newFcmToken) async {
    if (uid.isEmpty || newFcmToken.isEmpty) {
      throw ArgumentError("UID and new FCM Token are required");
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference userRef = db.collection("Users").doc(uid);

    DocumentSnapshot userSnap = await userRef.get();

    if (userSnap.exists) {
      Map<String, dynamic>? userData = userSnap.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('fcmToken')) {
        // Update existing fcmToken
        await userRef.update({'fcmToken': newFcmToken});
      } else {
        // Append fcmToken if it does not exist
        await userRef.set({'fcmToken': newFcmToken}, SetOptions(merge: true));
      }
    }

    print("FCM Token updated successfully");
  }

  Future<String?> fetchFcmToken() async {
    try {
      // Reference to the Admin collection
      CollectionReference adminCollection = FirebaseFirestore.instance.collection('Admin');

      // Fetch all documents in the Admin collection
      QuerySnapshot querySnapshot = await adminCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document in the collection
        DocumentSnapshot adminDoc = querySnapshot.docs.first;

        // Extract the fcmToken field
        String? fcmToken = adminDoc.get('fcmToken'); // Use 'get' to fetch the field
        print('FCM Token: $fcmToken');
        return fcmToken;
      } else {
        print('No documents found in the Admin collection.');
        return null;
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  Future<void> sendNotification(String fcmToken, String title, String body) async {
    final get = get_server_key();
    await get.server_token().then((value) async {
      String serverKey =
          value;


      final Uri url = Uri.parse('https://fcm.googleapis.com/v1/projects/code-x-clock/messages:send');

      final message = {
        "message": {
          "token": fcmToken,
          "data": {
            "title": title,
            "body": body
          }
        }


      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKey',
          },
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          debugPrint('Notification sent successfully.');
        } else {
          debugPrint('Error sending notification: ${response.body}');
        }
      } catch (e) {
        debugPrint('Exception sending notification: $e');
      }
    });

  }
}
