import 'package:googleapis/fcm/v1.dart';
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:uuid/uuid.dart';
import 'package:zp_timetable_update/bl/const.dart';

class CommonRepository {
  static Future<void> createNotification({
    required AuthClient client,
    required String groupId,
    required int weekNumber,
    required int dayNumber,
  }) async {
    FirebaseCloudMessagingApi firebaseCloudMessagingApi =
        FirebaseCloudMessagingApi(
      client,
    );

    SendMessageRequest request = SendMessageRequest();
    Message requestMessage = Message();

    Map<String, String> notificationData = Map<String, String>();
    notificationData['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
    notificationData['weekNumber'] = weekNumber.toString();
    notificationData['dayNumber'] = (dayNumber - 1).toString();
    notificationData['badge'] = '1';

    requestMessage.data = notificationData;

    requestMessage.topic = 'group.' + groupId;

    AndroidConfig androidConfig = AndroidConfig();
    AndroidNotification androidNotification = AndroidNotification();

    androidNotification.tag = 'timetable update';
    androidNotification.visibility = 'PUBLIC';
    androidNotification.notificationPriority = 'PRIORITY_HIGH';

    androidConfig.notification = androidNotification;
    androidConfig.directBootOk = true;

    requestMessage.android = androidConfig;

    ApnsConfig apnsConfig = ApnsConfig();

    apnsConfig.payload = {
      "aps": {
        "contentAvailable": true,
      },
      "category": "timetable_update",
    };

    requestMessage.apns = apnsConfig;

    Notification notification = Notification();
    notification.title = 'Зміни в розкладі';
    notification.body = 'В ваш розклад були внесені зміни';

    requestMessage.notification = notification;

    request.message = requestMessage;

    await firebaseCloudMessagingApi.projects.messages
        .send(request, 'projects/${Const.FirebaseProjectId}');
  }

  static Document createActivityCancelDocument({
    required String activityTimeStart,
    required DateTime dateTime,
    required String key,
    required String keyValue,
    required String id,
  }) {
    var uuid = Uuid();

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
    document.name =
        'projects/${Const.FirebaseProjectId}/databases/(default)/documents/timetable_items_update/' +
            uuid.v4();

    return document;
  }
}
