import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationBloc {
  StreamController<String> _controller = StreamController()..add(null);

  Stream<String> get pushNotification => _controller.stream;

  void subscribeToNew(String topic) => pushNotification
      .where((lastTopic) => lastTopic != null)
      .asyncMap(FirebaseMessaging.instance.unsubscribeFromTopic)
      .asyncMap((_) => FirebaseMessaging.instance.subscribeToTopic(topic))
      .listen((_) => _controller.add(topic));

  void dispose() {
    _controller.close();
  }
}
