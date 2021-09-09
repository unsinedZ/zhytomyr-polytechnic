import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:push_notification/src/bl/models/group.dart';

class PushNotificationBloc {
  final StreamSink<String> errorSink;
  final StreamController<String?> _pushNotificationController =
      StreamController.broadcast();
  final StreamController<String?> _onNotificationOpenedController =
      StreamController.broadcast();

  PushNotificationBloc({required this.errorSink});

  String? lastTopic;

  Stream<String?> get pushNotification => _pushNotificationController.stream;
  Stream<String?> get onMessageOpened => _onNotificationOpenedController.stream;

  void init() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _onNotificationOpenedController.add(jsonEncode(message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onNotificationOpenedController.add(jsonEncode(message.data));
    });

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      _onNotificationOpenedController.add(payload);
    });
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.notification != null) {
        _showInAppNotification(
            flutterLocalNotificationsPlugin,
            message.notification!.title ?? '',
            message.notification!.body ?? '',
            message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _showInAppNotification(
            flutterLocalNotificationsPlugin,
            message.notification!.title ?? '',
            message.notification!.body ?? '',
            message.data);
      }
    });
  }

  void subscribeToNew(String groupId, String subgroupId) {
    try {
      Group newGroup = Group(groupId: groupId, subgroupId: subgroupId);

      if (lastTopic != null && lastTopic == newGroup.toTopic) {
        return;
      }

      FirebaseMessaging.instance.subscribeToTopic(newGroup.toTopic);

      if (lastTopic == null) {
        lastTopic = newGroup.toTopic;
      } else if (lastTopic != newGroup.toTopic) {
        FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!);
      }
    } catch (err) {
      errorSink.add(err.toString());
    }
  }

  void _showInAppNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body,
      Map<String, dynamic> payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'zp_chanel', 'zp', 'chanel for timetable update notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  void unsubscribeFromCurrentTopic() {
    if (lastTopic != null) {
      FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!);
      lastTopic = null;
    }
  }

  void dispose() {
    _pushNotificationController.close();
  }
}
