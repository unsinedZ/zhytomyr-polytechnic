import 'dart:convert';

import 'package:googleapis/firestore/v1.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:timetable/timetable.dart';
import 'package:zp_timetable_update/bl/const.dart';

import 'package:zp_timetable_update/bl/models/expirable.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';
import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';
import 'package:zp_timetable_update/bl/repositories/common_repository.dart';

class TutorTimetableFirestoreRepository implements TimetableRepository {
  final Future<SharedPreferences> sharedPreferences;
  final ValueStream<AuthClient?> clientStream;
  final ValueStream<int?> tutorIdStream;

  TutorTimetableFirestoreRepository({
    required this.sharedPreferences,
    required this.clientStream,
    required this.tutorIdStream,
  });

  @override
  Future<Timetable> loadTimetableByReferenceId() async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    final SharedPreferences prefs = await sharedPreferences;

    Timetable? timetable;
    TimetableData timetableData;

    timetableData = (await TimetableUpdateApi.runQuery(
      fieldPath: 'enabled',
      fieldValue: '1',
      collectionId: 'timetables',
      valueType: ValueType.Int,
      client: clientStream.value!,
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
        fieldValue: 'tutor/' + tutorIdStream.value!.toString(),
        collectionId: 'timetable_items_tutor',
        valueType: ValueType.String,
        client: clientStream.value!,
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
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    List<TimetableItemUpdate> timetableUpdates =
        await TimetableUpdateApi.runQuery(
      fieldPath: 'tutorKey',
      fieldValue: 'tutor/' + tutorIdStream.value!.toString(),
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: clientStream.value!,
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
  Future<void> cancelLesson(Activity activity, DateTime dateTime) async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    var uuid = Uuid();
    String id = uuid.v4();
    FirestoreApi firestoreApi = FirestoreApi(clientStream.value!);

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

      CommonRepository.createNotification(
          clientStream.value!, group.id.toString());
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
        'projects/${Const.FirebaseProjectId}/databases/(default)');
  }

  @override
  Future<void> deleteTimetableUpdate(String id) async {
    if (!clientStream.hasValue ||
        !tutorIdStream.hasValue ||
        clientStream.value == null ||
        tutorIdStream.value == null) {
      throw 'Unauthorized';
    }

    FirestoreApi firestoreApi = FirestoreApi(clientStream.value!);

    await TimetableUpdateApi.runQuery(
      fieldPath: 'id',
      fieldValue: id,
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: clientStream.value!,
    ).then(
      (docs) async {
        CommitRequest commitRequest = CommitRequest();

        commitRequest.writes = docs.map((doc) {
          Value? groupKeyValue = doc.fields?['groupKey'];
          if (groupKeyValue != null &&
              groupKeyValue.stringValue != null &&
              groupKeyValue.stringValue != '') {
            CommonRepository.createNotification(
                clientStream.value!, groupKeyValue.stringValue!.substring(6));
          }

          return (Write()..delete = doc.name!);
        }).toList();

        await firestoreApi.projects.databases.documents.commit(commitRequest,
            'projects/${Const.FirebaseProjectId}/databases/(default)');
      },
    );
  }
}
