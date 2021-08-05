import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/update_form.dart';
import 'package:uuid/uuid.dart';

import 'common_repository.dart';

class TimetableUpdateRepository implements ITimetableUpdateRepository {
  @override
  Future<void> addTimetableUpdate(
    AuthClient client,
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
  ) async {
    var uuid = Uuid();
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    List<Document> documents = timetableItemUpdate.toDocuments();

    CommitRequest commitRequest = CommitRequest();

    commitRequest.writes = [];

    documents.forEach((document) {
      document.name =
          'projects/emulator/databases/(default)/documents/timetable_items_update/' + // TODO - change
              uuid.v4();
      commitRequest.writes!.add(Write()..update = document);
    });

    groups.forEach((group) {
      CommonRepository.createNotification(client, group.id.toString());
    });

    if (initialGroups != null) {
      initialGroups
          .where((initialGroup) =>
              groups.every((group) => group.id != initialGroup.id))
          .forEach((group) {
        CommonRepository.createNotification(client, group.id.toString());

        commitRequest.writes!.add(Write()
          ..update = CommonRepository.createActivityCancelDocument(
            activityTimeStart:
                timetableItemUpdate.timetableItem!.activity.time.start,
            dateTime:
                DateTime.parse(timetableItemUpdate.date.replaceAll('/', '-')),
            key: 'groupKey',
            keyValue: 'group/' + group.id.toString(),
            id: documents.first.fields!['id']!.stringValue!,
          ));
      });
    }

    await firestoreApi.projects.databases.documents.commit(commitRequest,
        'projects/emulator/databases/(default)'); // TODO - change
  }
}
