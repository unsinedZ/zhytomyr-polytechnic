import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis/fcm/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/update_form.dart';

class TimetableUpdateRepository implements ITimetableUpdateRepository {
  @override
  Future<void> addTimetableUpdate(AuthClient client, Document document,
      List<Group> groups, List<Tutor> tutors) async {
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    await firestoreApi.projects.databases.documents.createDocument(
        document,
        'projects/emulator/databases/(default)/documents',
        'timetable_items_update',
        documentId: document.fields!['id']!.stringValue);
    createNotification(client, groups.first.id.toString());
    return null;
  }

  Future<void> createNotification(AuthClient client, String groupId) async {
    FirebaseCloudMessagingApi firebaseCloudMessagingApi =
        FirebaseCloudMessagingApi(
      client,
      // rootUrl: 'http://127.0.0.1:8080/',
    );

    SendMessageRequest request = SendMessageRequest();
    Message requestMessage = Message();

    requestMessage.name = 'someTestName';
    requestMessage.topic = 'group.' + groupId;

    AndroidConfig androidConfig = AndroidConfig();
    AndroidNotification androidNotification = AndroidNotification();

    androidNotification.title = 'title';
    androidNotification.body = 'body';

    androidConfig.notification = androidNotification;

    requestMessage.android = androidConfig;

    Notification notification = Notification();
    notification.title = 'Зміни в розкладі';
    notification.body = 'В ваш розклад були додані зміни';

    requestMessage.notification = notification;

    request.message = requestMessage;

    Message message = await firebaseCloudMessagingApi.projects.messages
        .send(request, 'projects/zhytomyr-politechnic-dev');
    print(message.name);
    print(message.topic);
  }
}
