import 'dart:async';

import 'package:push_notification/src/bl/models/group.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationBloc {
  final StreamController<String?> _pushNotificationController =
      StreamController.broadcast();
  Stream<String?> get pushNotification => _pushNotificationController.stream;

  void subscribeToNew(Map<String, dynamic> user) => pushNotification
      .asyncMap((lastTopic) =>
          FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!))
      .map((_) => Group.fromJson(user))
      .doOnData((group) => _pushNotificationController.add(group.toTopic))
      .asyncMap((group) =>
          FirebaseMessaging.instance.subscribeToTopic(group.toTopic))
      .toList();

  void dispose() {
    _pushNotificationController.close();
  }
}
