import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';

class GroupTimetableFirestoreRepository implements TimetableRepository {
  final Future<SharedPreferences> sharedPreferences;
  final FirebaseFirestore firebaseFirestoreInstance;

  GroupTimetableFirestoreRepository({
    required this.sharedPreferences,
    required this.firebaseFirestoreInstance,
  });

  @override
  Future<Timetable> loadTimetableByReferenceId(int id,
      [String? userGroupId]) async {
    final SharedPreferences prefs = await sharedPreferences;

    Timetable? timetable;
    TimetableData timetableData;

    timetableData = TimetableData.fromJson((await firebaseFirestoreInstance
            .collection('timetables')
            .where("enabled", isEqualTo: 1)
            .get())
        .docs
        .map((doc) => doc.data())
        .first);

    if (prefs.containsKey('timetable.group.my') &&
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
      List<dynamic> itemsJson = (await firebaseFirestoreInstance
              .collection('timetable_items_group')
              .where("key", isEqualTo: 'group/' + id.toString())
              .get())
          .docs
          .map((doc) => doc.data())
          .first['items'];

      timetable = Timetable(
        timetableData: timetableData,
        items: itemsJson
            .map((itemJson) => TimetableItem.fromJson(itemJson))
            .toList(),
      );

      if (userGroupId == id.toString()) {
        Expirable<Map<String, dynamic>> expirableTimetableJson =
            Expirable<Map<String, dynamic>>(
          duration: Duration(days: 30),
          data: timetable.toJson(),
        );

        prefs.setString(
          'timetable.group.my',
          jsonEncode(expirableTimetableJson),
        );
      }
    }

    return timetable;
  }

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id) async {
    return firebaseFirestoreInstance
        .collection('timetable_items_update')
        .where('key', isEqualTo: 'group/' + id.toString())
        .get()
        .then(
          (timetableItemUpdateListJson) => timetableItemUpdateListJson.docs
              .map(
                (timetableItemUpdateJson) => TimetableItemUpdate.fromJson(
                    timetableItemUpdateJson.data()),
              )
              .toList(),
        );
  }
}
