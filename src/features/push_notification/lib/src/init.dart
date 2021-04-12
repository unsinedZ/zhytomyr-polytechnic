import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging get initNotification => FirebaseMessaging.instance
    ..requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
