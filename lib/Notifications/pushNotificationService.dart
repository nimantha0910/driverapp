import 'dart:io' show Platform;
import 'dart:math';

import 'package:driverapp/configMaps.dart';
import 'package:driverapp/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDqHduERKxoo_NSlDgPKhsv_9LSYXzVajs",
        appId: "1:16696135279:web:66158d536e07103fb5879a",
        messagingSenderId: "16696135279",
        projectId: "rider-app-29f66",
      ),
    );
    print("Handling a background message: ${message.messageId}");
  }

  Future initialize() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((event) {
      print(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => print(value));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    print("This is token:: ");
    print(token);
    driversRef.child(currentfirebaseUser!.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String? getDriverRequestId(Map<String, dynamic> message) {
    String driverRequestId = "";
    if (Platform.isAndroid) {
      driverRequestId = message['data']['driver_request_id'];
    } else {
      driverRequestId = message['driver_request_id'];
    }
    return driverRequestId;
  }
}
