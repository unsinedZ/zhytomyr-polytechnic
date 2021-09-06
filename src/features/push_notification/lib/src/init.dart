import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging initNotification() => FirebaseMessaging.instance
    ..requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    )..getToken().then((value) => print(value));