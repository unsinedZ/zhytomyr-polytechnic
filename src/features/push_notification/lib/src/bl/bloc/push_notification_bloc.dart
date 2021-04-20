import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification/src/bl/models/group.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationBloc {
  final StreamController<String?> _controller = StreamController.broadcast();
  Stream<String?> get pushNotification => _controller.stream;

  void subscribeToNew(Map<String, dynamic> user) => pushNotification
      .asyncMap((lastTopic) =>
          FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!))
      .map((_) => Group.fromJson(user))
      .switchMap((group) => Stream.empty()
          .asyncMap((_) => FirebaseMessaging.instance
              .subscribeToTopic("group." + group.toTopic))
          .doOnData((_) => _controller.add(group.toTopic)));

  void dispose() {
    _controller.close();
  }
}
