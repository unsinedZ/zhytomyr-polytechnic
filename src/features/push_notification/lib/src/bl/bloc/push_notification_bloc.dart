import 'dart:async';

import 'package:push_notification/src/bl/models/group.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationBloc {
  final StreamSink<String> errorSink;
  final StreamController<String?> _pushNotificationController =
      StreamController.broadcast();

  PushNotificationBloc({required this.errorSink});

  Stream<String?> get pushNotification => _pushNotificationController.stream;

  void subscribeToNew(String groupId, String subgroupId) =>
      Stream.value(Group(groupId: groupId, subgroupId: subgroupId))
          .doOnData((group) =>
              FirebaseMessaging.instance.subscribeToTopic(group.toTopic))
          .switchMap((group) => pushNotification
              .take(1)
              .doOnData((_) => _pushNotificationController.add(group.toTopic))
              .where((lastTopic) =>
                  lastTopic != group.toTopic && lastTopic!.isNotEmpty)
              .asyncMap((lastTopic) =>
                  FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!))
              .doOnError((error, _) => errorSink.add(error.toString())))
          .toList();

  void dispose() {
    _pushNotificationController.close();
  }
}
