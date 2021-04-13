import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationBloc {
  StreamController<String?> _controller = StreamController()..add(null);
  Stream<String?> get pushNotification => _controller.stream;

  void subscribeToNew(String topic) => pushNotification
      .asyncMap((_) => SharedPreferences.getInstance())
      .map((lastItem) => lastItem.getString("subscription"))
      .asyncMap((_) => FirebaseMessaging.instance.subscribeToTopic(topic))
      // .map((lastItem) => lastItem.setString("subscription", topic))
      // .where((lastTopic) => lastTopic!.isNotEmpty)
      // .asyncMap((lastTopic) =>
          // FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!))
      .listen((_) => _controller.add(topic));

  void dispose() {
    _controller.close();
  }
}
