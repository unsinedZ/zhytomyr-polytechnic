import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationBloc {
  late StreamController<String?> _controller;
  Stream<String?> get pushNotification => _controller.stream;

  PushNotificationBloc() {
    _controller = StreamController();
    SharedPreferences.getInstance()
        .asStream()
        .map((preferences) => preferences.getString("subscription"))
        .map(_controller.add);
  }

  void subscribeToNew(String topic) => pushNotification.switchMap((lastTopic) =>
      SharedPreferences.getInstance().asStream().switchMap((prefs) => Stream.value(prefs)
          .asyncMap(
              (preferences) => preferences.setString("subscription", topic))
          .doOnData((_) => _controller.add(topic))
          .asyncMap((_) => FirebaseMessaging.instance.subscribeToTopic(topic))
          .map((_) => lastTopic)
          .where((lastTopic) => lastTopic != null)
          .switchMap((value) => Stream.value(value).asyncMap((_) =>
              FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!)))));

  void dispose() {
    _controller.close();
  }
}
