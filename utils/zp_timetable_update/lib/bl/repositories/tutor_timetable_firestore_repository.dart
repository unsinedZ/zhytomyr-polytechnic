import 'dart:convert';

import 'package:googleapis/firestore/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:timetable/timetable.dart';

import 'package:zp_timetable_update/bl/models/expireble.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';
import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';
import 'package:zp_timetable_update/bl/repositories/common_repository.dart';

class TutorTimetableFirestoreRepository implements TimetableRepository {
  final AuthClient client;
  final Future<SharedPreferences> sharedPreferences;

  TutorTimetableFirestoreRepository({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<Timetable> loadTimetableByReferenceId(int id) async {
    final SharedPreferences prefs = await sharedPreferences;

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
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id) async {
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
  Future<void> cancelLesson(Activity activity, DateTime dateTime) async {
    var uuid = Uuid();
    String id = uuid.v4();
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    var futures = <Future>[];

    activity.groups.forEach((group) async {
      futures.add(CommonRepository.cancelActivity(
          activityTimeStart: activity.time.start,
          dateTime: dateTime,
          id: id,
          firestoreApi: firestoreApi,
          key: 'groupKey',
          keyValue: 'group/' + group.id.toString()));
      CommonRepository.createNotification(client, group.id.toString());
    });

    activity.tutors.forEach((tutor) async {
      futures.add(CommonRepository.cancelActivity(
          activityTimeStart: activity.time.start,
          dateTime: dateTime,
          id: id,
          firestoreApi: firestoreApi,
          key: 'tutorKey',
          keyValue: 'tutor/' + tutor.id.toString()));
    });

    await Future.wait(futures);

    return null;
  }

  @override
  Future<void> deleteTimetableUpdate(String id) async {
    FirestoreApi firestoreApi =
        FirestoreApi(client, rootUrl: 'http://127.0.0.1:8080/');

    var futures = <Future>[];

    await TimetableUpdateApi.runQuery(
      fieldPath: 'id',
      fieldValue: id,
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: client,
    ).then(
      (docs) => docs.map(
        (timetableItemUpdate) async {
          Value? groupKeyValue = timetableItemUpdate.fields?['groupKey'];
          if(groupKeyValue != null && groupKeyValue.stringValue != null && groupKeyValue.stringValue != '') {
            CommonRepository.createNotification(client, groupKeyValue.stringValue!.substring(6));
          }
          futures.add(firestoreApi.projects.databases.documents
              .delete(timetableItemUpdate.name!));
        },
      ).toList(),
    );

    await Future.wait(futures);

    return null;
  }
}
