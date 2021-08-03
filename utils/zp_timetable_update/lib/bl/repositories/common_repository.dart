import 'package:googleapis/fcm/v1.dart';
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class CommonRepository {
  static Future<void> createNotification(AuthClient client, String groupId) async {
    FirebaseCloudMessagingApi firebaseCloudMessagingApi =
    FirebaseCloudMessagingApi(
      client,
      // rootUrl: 'http://127.0.0.1:8080/',
    );

    SendMessageRequest request = SendMessageRequest();
    Message requestMessage = Message();

    requestMessage.topic = 'group.' + groupId;

    AndroidConfig androidConfig = AndroidConfig();
    AndroidNotification androidNotification = AndroidNotification();

    androidNotification.tag = 'timetable update';
    androidNotification.visibility = 'PUBLIC';

    androidConfig.notification = androidNotification;
    androidConfig.directBootOk = true;


    requestMessage.android = androidConfig;

    Notification notification = Notification();
    notification.title = 'Зміни в розкладі';
    notification.body = 'В ваш розклад були внесені зміни';

    requestMessage.notification = notification;

    request.message = requestMessage;

    Message message = await firebaseCloudMessagingApi.projects.messages
        .send(request, 'projects/zhytomyr-politechnic-dev');
  }

  static Future<dynamic> cancelActivity({
    required String activityTimeStart,
    required DateTime dateTime,
    required String key,
    required String keyValue,
    required String id,
    required FirestoreApi firestoreApi,
  }) {
    String date = dateTime.year.toString() +
        '-' +
        (dateTime.month < 10
            ? ('0' + dateTime.month.toString())
            : dateTime.month.toString()) +
        '-' +
        (dateTime.day < 10
            ? '0' + dateTime.day.toString()
            : dateTime.day.toString());

    Document document = Document();

    Map<String, Value> fields = {
      'date': Value()..stringValue = date,
      'time': Value()..stringValue = activityTimeStart,
      key: Value()..stringValue = keyValue,
      'id': Value()..stringValue = id,
    };

    document.fields = fields;

    return firestoreApi.projects.databases.documents.createDocument(
        document,
        'projects/emulator/databases/(default)/documents',
        'timetable_items_update');
  }
}
