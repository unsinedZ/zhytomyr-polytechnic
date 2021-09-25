import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:rxdart/rxdart.dart';

import 'package:update_form/update_form.dart';
import 'package:uuid/uuid.dart';
import 'package:zp_timetable_update/bl/const.dart';

import 'package:zp_timetable_update/bl/extensions/document_extension.dart';
import 'package:zp_timetable_update/bl/repositories/common_repository.dart';
import 'package:zp_timetable_update/bl/services/memory_cache_service.dart';

class TimetableUpdateRepository implements ITimetableUpdateRepository {
  final ValueStream<AuthClient?> clientStream;
  final ValueStream<int?> tutorIdStream;
  final MemoryCacheService memoryCacheService;

  static const namesKey = 'activityNames';

  TimetableUpdateRepository({
    required this.clientStream,
    required this.tutorIdStream,
    required this.memoryCacheService,
  });

  @override
  Future<void> addTimetableUpdate(
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
    int weekNumber,
    int dayNumber,
  ) async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    var uuid = Uuid();
    FirestoreApi firestoreApi = FirestoreApi(clientStream.value!);

    List<Document> documents = timetableItemUpdate.toDocuments();

    CommitRequest commitRequest = CommitRequest();

    commitRequest.writes = [];

    documents.forEach((document) {
      document.name =
          'projects/${Const.FirebaseProjectId}/databases/(default)/documents/timetable_items_update/' +
              uuid.v4();
      commitRequest.writes!.add(Write()..update = document);
    });

    groups.forEach((group) {
      CommonRepository.createNotification(
        client: clientStream.value!,
        groupId: group.id.toString(),
        weekNumber: weekNumber,
        dayNumber: dayNumber,
      );
    });

    if (initialGroups != null) {
      initialGroups
          .where((initialGroup) =>
              groups.every((group) => group.id != initialGroup.id))
          .forEach((group) {
        CommonRepository.createNotification(
          client: clientStream.value!,
          groupId: group.id.toString(),
          weekNumber: weekNumber,
          dayNumber: dayNumber,
        );

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
        'projects/${Const.FirebaseProjectId}/databases/(default)');
  }

  @override
  Future<List<ActivityName>> loadSubjectNames() async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    var cachedNames = memoryCacheService.get(namesKey);
    if (cachedNames != null && cachedNames is List<ActivityName>) {
      print('Load from cache');
      return cachedNames;
    }

    FirestoreApi firestoreApi = FirestoreApi(clientStream.value!);

    List<ActivityName> subjectNames = [];

    ListDocumentsResponse response =
        await firestoreApi.projects.databases.documents.list(
      'projects/${Const.FirebaseProjectId}/databases/(default)/documents',
      'subjects',
      pageSize: 1000,
    );

    if (response.documents == null) {
      return [];
    }

    subjectNames.addAll(response.documents!.map((activityNameDocument) =>
        ActivityName.fromJson(activityNameDocument.toJsonFixed())));

    while (response.nextPageToken != null) {
      response = await firestoreApi.projects.databases.documents.list(
          'projects/${Const.FirebaseProjectId}/databases/(default)/documents',
          'subjects',
          pageSize: 1000,
          pageToken: response.nextPageToken);

      subjectNames.addAll(response.documents!.map((activityNameDocument) =>
          ActivityName.fromJson(activityNameDocument.toJsonFixed())));
    }

    memoryCacheService.addOrUpdate(namesKey, subjectNames, Duration(days: 1));
    return subjectNames;
  }
}
