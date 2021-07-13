import 'dart:convert';

import 'package:authorization_bloc/authorization_bloc.dart';
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

    if (prefs.containsKey('timetable.teacher') &&
        userGroupId == id.toString() &&
        timetableData.expiredAt.isAfter(DateTime.now())) {
      Map<String, dynamic> json =
          jsonDecode(prefs.getString('timetable.group.my')!);
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
          print(docs.first.toJsonFixed()['items']);
          return Timetable(
            timetableData: timetableData,
            items: (docs.first.toJsonFixed()['items'] as List<dynamic>)
                .map((itemJson) => TimetableItem.fromJson(itemJson))
                .toList());
        },
      );
      // List<dynamic> itemsJson = (await firebaseFirestoreInstance
      //         .collection('timetable_items_group')
      //         .where("key", isEqualTo: 'group/' + id.toString())
      //         .get())
      //     .docs
      //     .map((doc) => doc.data())
      //     .first['items'];
      //
      // timetable = Timetable(
      //   timetableData: timetableData,
      //   items: itemsJson
      //       .map((itemJson) => TimetableItem.fromJson(itemJson))
      //       .toList(),
      // );

      if (userGroupId == id.toString()) {
        Expirable<Map<String, dynamic>> expirableTimetableJson =
            Expirable<Map<String, dynamic>>(
          duration: Duration(days: 30),
          data: timetable!.toJson(),
        );

        prefs.setString(
          'timetable.teacher',
          jsonEncode(expirableTimetableJson),
        );
      }
    }

    return timetable!;
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id) async {
    return [];
    List<TimetableItemUpdate> timetableUpdates =
        await TimetableUpdateApi.runQuery(
      fieldPath: 'key',
      fieldValue: 'group/' + id.toString(),
      collectionId: 'timetable_items_update',
      valueType: ValueType.String,
      client: client,
    ).then(
      (docs) => docs
          .map(
            (timetableItemUpdateJson) =>
                TimetableItemUpdate.fromJson(timetableItemUpdateJson.toJson()),
          )
          .toList(),
    );

    return timetableUpdates;
  }
}
