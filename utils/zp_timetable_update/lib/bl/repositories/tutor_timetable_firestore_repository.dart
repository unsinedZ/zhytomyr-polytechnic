import 'dart:convert';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:googleapis/firestore/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';

import 'package:zp_timetable_update/bl/models/expireble.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';
import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';

class TutorTimetableFirestoreRepository implements TimetableRepository {
  final AuthClient client;
  final Future<SharedPreferences> sharedPreferences;

  TutorTimetableFirestoreRepository({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<Timetable> loadTimetableByReferenceId(int id,
      [String? userGroupId]) async {
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
        userGroupId == id.toString() &&
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

      if (userGroupId == id.toString()) {
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
    }

    return timetable!;
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id) async {
    //return [];
    List<TimetableItemUpdate> timetableUpdates =
        await TimetableUpdateApi.runQuery(
      fieldPath: 'tutorKey',
      fieldValue: 'tutor/' + id.toString(),
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: client,
    ).then(
      (docs) => docs
          .map(
            (timetableItemUpdateJson) => TimetableItemUpdate.fromJson(
                timetableItemUpdateJson.toJsonFixed()),
          )
          .toList(),
    );

    return timetableUpdates;
  }

  @override
  Future<void> cancelLesson(Activity activity, DateTime dateTime) async {
    FirestoreApi firestoreApi = FirestoreApi(client, rootUrl: 'http://127.0.0.1:9190/');

    String date = dateTime.year.toString() +
        '-' +
        (dateTime.month < 10 ? ('0' + dateTime.month.toString()) : dateTime.month.toString()) +
        '-' +
        (dateTime.day < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString());

    Document document = Document();
    Map<String, Value> fields = {
      'date': Value()
        ..stringValue = date,
      'time': Value()..stringValue = activity.time.start,
      'groupKey': Value()
        ..stringValue = 'group/' + activity.groups.first.id.toString(),
      'tutorKey': Value()
        ..stringValue = 'tutor/' + activity.tutors.first.id.toString(),
    };

    document.fields = fields;

    await firestoreApi.projects.databases.documents.createDocument(
        document,
        'projects/emulator/databases/(default)/documents',
        'timetable_items_update');
    return null;
  }
}
