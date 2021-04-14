import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationBloc {
  final StreamController<String?> _controller = StreamController.broadcast();
  Stream<String?> get pushNotification => _controller.stream;

  PushNotificationBloc() {
    SharedPreferences.getInstance()
        .then((prefs) => _controller.add(prefs.getString("subscription")));
  }

  void subscribeToNew(String topic) {
    pushNotification
        .asyncMap((lastTopic) =>
            FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!))
        .doOnData((_) => _controller.add(topic))
        .asyncMap((_) =>
            FirebaseMessaging.instance.subscribeToTopic("group." + topic))
        .asyncMap((_) async => (await SharedPreferences.getInstance())
            .setString("subscription", "group." + topic));
    FirebaseMessaging.instance.subscribeToTopic("group." + topic);
  }

  void dispose() {
    _controller.close();
  }
}
