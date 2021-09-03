import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:googleapis/firestore/v1.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timetable/timetable.dart' hide Group;
import 'package:update_form/update_form.dart' hide Tutor;

import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';
import 'package:zp_timetable_update/bl/const.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';

class MainFirestoreRepository
    implements TutorRepository, IGroupsRepository {
  final ValueStream<AuthClient?> clientStream;
  final ValueStream<int?> tutorIdStream;

  MainFirestoreRepository(
    this.clientStream,
    this.tutorIdStream,
  );

  @override
  Future<Tutor?> getTutorById() async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    List<Tutor> tutors = (await TimetableUpdateApi.runQuery(
      client: clientStream.value!,
      collectionId: 'tutors',
      fieldPath: 'id',
      fieldValue: tutorIdStream.value.toString(),
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
  Future<List<Group>> getGroups() async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    FirestoreApi firestoreApi =
        FirestoreApi(clientStream.value!);

    List<Group> groups = [];

    ListDocumentsResponse groupsResponse =
        await firestoreApi.projects.databases.documents.list(
      'projects/${Const.FirebaseProjectId}/databases/(default)/documents',
      'groups',
      pageSize: 1000,
    );

    if (groupsResponse.documents == null) {
      return [];
    }

    groups.addAll(groupsResponse.documents!
        .map((groupDocument) => Group.fromJson(groupDocument.toJsonFixed())));

    while (groupsResponse.nextPageToken != null) {
      groupsResponse = await firestoreApi.projects.databases.documents
          .list('projects/${Const.FirebaseProjectId}/databases/(default)/documents', 'groups',
              pageSize: 10000,
              pageToken: groupsResponse.nextPageToken);

      groups.addAll(groupsResponse.documents!
          .map((groupDocument) => Group.fromJson(groupDocument.toJsonFixed())));
    }

    return groups;
  }
}
