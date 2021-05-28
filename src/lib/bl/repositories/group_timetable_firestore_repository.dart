import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/base_timetable_firestore_repository.dart';

class GroupTimetableFirestoreRepository extends BaseTimetableFirestoreRepository
    implements TimetableRepository {
  final Future<SharedPreferences> sharedPreferences;
  final FirebaseFirestore firebaseFirestoreInstance;

  GroupTimetableFirestoreRepository({
    required this.sharedPreferences,
    required this.firebaseFirestoreInstance,
  }) : super(firebaseFirestoreInstance: firebaseFirestoreInstance);

  @override
  Future<Timetable> loadTimetableByReferenceId(int id,
      [String? userGroupId]) async {
    final SharedPreferences prefs = await sharedPreferences;

    Timetable? timetable;
    TimetableData timetableData;

    timetableData = TimetableData.fromJson((await firebaseFirestoreInstance
            .collection('timetable')
            //.where("enabled", isEqualTo: 1) // TODO
            .get())
        .docs
        .map((doc) => doc.data())
        .first);

    if (prefs.containsKey('timetable.group.my') &&
        userGroupId == id.toString()) {
      // TODO make userGroupId int
      Map<String, dynamic> json =
          jsonDecode(prefs.getString('timetable.group.my')!);
      json['data'] = (json['data'] as Map<String, dynamic>);

      Expirable<Map<String, dynamic>> expirableTimetableJson =
          Expirable<Map<String, dynamic>>.fromJson(json);

      if (expirableTimetableJson.expireAt.isAfter(DateTime.now())) {
        timetable = Timetable.fromJson(expirableTimetableJson.data);
        if (timetable.timetableData.lastModified !=
                timetableData.lastModified ||
            timetableData.expiredAt.isBefore(DateTime.now())) {
          timetable = null;
        }
      }
    }

    if (timetable == null) {
      List<dynamic> itemsJson = (await firebaseFirestoreInstance
              .collection('timetable_item_group')
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

      // List<TimetableItem> items = timetable.items // TODO delete
      //     .where((element) =>
      //         element.activity.groups.any((group) => group.id == key))
      //     .toList();
      //
      // timetable = Timetable(
      //   weekDetermination: timetable.weekDetermination,
      //   items: items,
      //   expiresAt: timetable.expiresAt,
      // ); // TODO delete

      // if (userGroupId == key) {
      //   Expirable<Map<String, dynamic>> expirableTimetableJson =
      //       Expirable<Map<String, dynamic>>(
      //     duration: Duration(days: 30),
      //     data: timetable.toJson(),
      //   );
      //
      //   prefs.setString(
      //       'timetable.group.my', jsonEncode(expirableTimetableJson));
      // }
    }

    return timetable;
  }
}
