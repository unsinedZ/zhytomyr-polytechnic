import 'dart:async';

import 'package:push_notification/src/bl/models/group.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationBloc {
  final StreamSink<String> errorSink;
  final StreamController<String?> _pushNotificationController =
      StreamController.broadcast();

  PushNotificationBloc({required this.errorSink});

  String? lastTopic;

  Stream<String?> get pushNotification => _pushNotificationController.stream;

  void subscribeToNew(String groupId, String subgroupId) {
    try {
      Group newGroup = Group(groupId: groupId, subgroupId: subgroupId);

      if(lastTopic != null && lastTopic == newGroup.toTopic){
        return;
      }

      FirebaseMessaging.instance.subscribeToTopic(newGroup.toTopic);

      if(lastTopic == null) {
        lastTopic = newGroup.toTopic;
      } else if(lastTopic != newGroup.toTopic) {
        FirebaseMessaging.instance.unsubscribeFromTopic(lastTopic!);
      }
    } catch (err) {
      errorSink.add(err.toString());
    }
  }

  void dispose() {
    _pushNotificationController.close();
  }
}
