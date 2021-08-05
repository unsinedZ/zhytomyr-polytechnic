import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:googleapis/firestore/v1.dart';

import 'package:timetable/timetable.dart' hide Group;
import 'package:update_form/update_form.dart' hide Tutor;

import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';

class MainFirestoreRepository implements TutorRepository, IGroupsRepository {
  @override
  Future<Tutor?> getTutorById(int teacherId, AuthClient client) async {
    List<Tutor> tutors = (await TimetableUpdateApi.runQuery(
      client: client,
      collectionId: 'tutors',
      fieldPath: 'id',
      fieldValue: teacherId.toString(),
      valueType: ValueType.Int,
    ))
        .map((tutorDocument) => Tutor.fromJson(tutorDocument.toJsonFixed()))
        .toList();

    if (tutors.isNotEmpty) {
      return tutors.first;
    } else {
      return null;
    }
  }

  @override
  Future<List<Group>> getGroups(AuthClient client) async {
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    List<Group> groups = [];

    ListDocumentsResponse groupsResponse =
        await firestoreApi.projects.databases.documents.list(
      'projects/emulator/databases/(default)/documents',
      'groups',
      pageSize: 1000,
    ); // TODO delete emulator

    if (groupsResponse.documents == null) {
      return [];
    }

    groups.addAll(groupsResponse.documents!
        .map((groupDocument) => Group.fromJson(groupDocument.toJsonFixed())));

    //print(groupsResponse.nextPageToken); // TODO - check with real firestore

    while (groupsResponse.nextPageToken != null) {
      groupsResponse = await firestoreApi.projects.databases.documents.list(
          'projects/emulator/databases/(default)/documents', 'groups',
          pageSize: 10000, pageToken: groupsResponse.nextPageToken);

      groups.addAll(groupsResponse.documents!
          .map((groupDocument) => Group.fromJson(groupDocument.toJsonFixed())));
    }

    return groups;
  }
}
