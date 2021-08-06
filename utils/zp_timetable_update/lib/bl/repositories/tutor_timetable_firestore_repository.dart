import 'dart:convert';

import 'package:googleapis/firestore/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:timetable/timetable.dart';

import 'package:zp_timetable_update/bl/models/expirable.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';
import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';
import 'package:zp_timetable_update/bl/repositories/common_repository.dart';

class TutorTimetableFirestoreRepository implements TimetableRepository {
  final Future<SharedPreferences> sharedPreferences;

  TutorTimetableFirestoreRepository({
    required this.sharedPreferences,
  });

  @override
  Future<Timetable> loadTimetableByReferenceId(int id, AuthClient client) async {
    final SharedPreferences prefs = await sharedPreferences;

    prefs.remove('timetable.tutor');

    Timetable? timetable;
    TimetableData timetableData;

    timetableData = (await TimetableUpdateApi.runQuery(
      fieldPath: 'enabled',
      fieldValue: '1',
      collectionId: 'timetables',
      valueType: ValueType.Int,
      client: client,
    ))
        .map(
      (timetableDataDoc) {
        return TimetableData.fromJson(
          timetableDataDoc.toJsonFixed(),
        );
      },
    ).first;

    if (prefs.containsKey('timetable.tutor') &&
        timetableData.expiredAt.isAfter(DateTime.now())) {
      Map<String, dynamic> json =
          jsonDecode(prefs.getString('timetable.tutor')!);
      json['data'] = (json['data'] as Map<String, dynamic>);

      Expirable<Map<String, dynamic>> expirableTimetableJson =
          Expirable<Map<String, dynamic>>.fromJson(json);

      if (expirableTimetableJson.expireAt.isAfter(DateTime.now())) {
        timetable = Timetable.fromJson(expirableTimetableJson.data);
        if (timetable.timetableData.lastModified !=
            timetableData.lastModified) {
          timetable = null;
        }
      }
    }

    if (timetable == null) {
      timetable = await TimetableUpdateApi.runQuery(
        fieldPath: 'key',
        fieldValue: 'tutor/' + id.toString(),
        collectionId: 'timetable_items_tutor',
        valueType: ValueType.String,
        client: client,
      ).then(
        (docs) {
          return Timetable(
              timetableData: timetableData,
              items: (docs.first.toJsonFixed()['items'] as List<dynamic>)
                  .map((itemJson) => TimetableItem.fromJson(itemJson))
                  .toList());
        },
      );

      Expirable<Map<String, dynamic>> expirableTimetableJson =
          Expirable<Map<String, dynamic>>(
        duration: Duration(days: 30),
        data: timetable!.toJson(),
      );

      prefs.setString(
        'timetable.tutor',
        jsonEncode(expirableTimetableJson),
      );
    }

    return timetable;
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id, AuthClient client) async {
    List<TimetableItemUpdate> timetableUpdates =
        await TimetableUpdateApi.runQuery(
      fieldPath: 'tutorKey',
      fieldValue: 'tutor/' + id.toString(),
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: client,
    ).then(
      (docs) => docs.map(
        (timetableItemUpdate) {
          return TimetableItemUpdate.fromJson(
              timetableItemUpdate.toJsonFixed());
        },
      ).toList(),
    );

    return timetableUpdates;
  }

  @override
  Future<void> cancelLesson(Activity activity, DateTime dateTime, AuthClient client) async {
    var uuid = Uuid();
    String id = uuid.v4();
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    CommitRequest commitRequest = CommitRequest();

    commitRequest.writes = [];

    activity.groups.forEach((group) async {
      commitRequest.writes!.add(Write()
        ..update = CommonRepository.createActivityCancelDocument(
            activityTimeStart: activity.time.start,
            dateTime: dateTime,
            id: id,
            key: 'groupKey',
            keyValue: 'group/' + group.id.toString()));

      CommonRepository.createNotification(client, group.id.toString());
    });

    activity.tutors.forEach((tutor) async {
      commitRequest.writes!.add(Write()
        ..update = CommonRepository.createActivityCancelDocument(
            activityTimeStart: activity.time.start,
            dateTime: dateTime,
            id: id,
            key: 'tutorKey',
            keyValue: 'tutor/' + tutor.id.toString()));
    });

    await firestoreApi.projects.databases.documents.commit(commitRequest,
        'projects/emulator/databases/(default)'); // TODO - change
  }

  @override
  Future<void> deleteTimetableUpdate(String id, AuthClient client) async {
    FirestoreApi firestoreApi = FirestoreApi(
      client,
      rootUrl: 'http://127.0.0.1:8080/', // TODO - delete
    );

    await TimetableUpdateApi.runQuery(
      fieldPath: 'id',
      fieldValue: id,
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: client,
    ).then(
      (docs) async {
        CommitRequest commitRequest = CommitRequest();

        commitRequest.writes = docs.map((doc) {
          Value? groupKeyValue = doc.fields?['groupKey'];
          if (groupKeyValue != null &&
              groupKeyValue.stringValue != null &&
              groupKeyValue.stringValue != '') {
            CommonRepository.createNotification(
                client, groupKeyValue.stringValue!.substring(6));
          }

          return (Write()..delete = doc.name!);
        }).toList();

        await firestoreApi.projects.databases.documents.commit(commitRequest,
            'projects/emulator/databases/(default)'); // TODO - change
      },
    );
  }
}
