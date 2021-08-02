import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/update_form.dart';
import 'common_repository.dart';

class TimetableUpdateRepository implements ITimetableUpdateRepository {
  @override
  Future<void> addTimetableUpdate(
      AuthClient client, List<Document> documents, List<Group> groups) async {
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    var futures = <Future>[];

    documents.forEach((document) {
      futures.add(firestoreApi.projects.databases.documents.createDocument(
        document,
        'projects/emulator/databases/(default)/documents',
        'timetable_items_update',
      ));
    });

    CommonRepository.createNotification(client, groups.first.id.toString());

    await Future.wait(futures);

    return null;
  }
}
