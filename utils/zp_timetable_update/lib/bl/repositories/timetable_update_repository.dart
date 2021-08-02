import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/update_form.dart';
import 'common_repository.dart';

class TimetableUpdateRepository implements ITimetableUpdateRepository {
  @override
  Future<void> addTimetableUpdate(
    AuthClient client,
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
  ) async {
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    List<Document> documents = timetableItemUpdate.toDocuments();

    var futures = <Future>[];

    documents.forEach((document) {
      futures.add(firestoreApi.projects.databases.documents.createDocument(
        document,
        'projects/emulator/databases/(default)/documents',
        'timetable_items_update',
      ));
    });

    groups.forEach((group) {
      CommonRepository.createNotification(client, group.id.toString());
    });
    if (initialGroups != null) {
      initialGroups
          .where((initialGroup) =>
              groups.every((group) => group.id != initialGroup.id))
          .forEach((group) {
        CommonRepository.cancelActivity(
            activityTimeStart: timetableItemUpdate.timetableItem!.activity.time.start,
            dateTime: DateTime.parse(timetableItemUpdate.date.replaceAll('/', '-')),
            key: 'groupKey',
            keyValue: 'group/' + group.id.toString(),
            id: documents.first.fields!['id']!.stringValue!,
            firestoreApi: firestoreApi);
      });
    }

    await Future.wait(futures);

    return null;
  }
}
