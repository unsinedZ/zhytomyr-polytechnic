import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';
import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';

class GroupTimetableFirestoreRepository
    implements TimetableRepository {
  final Future<SharedPreferences> sharedPreferences;
  final FirebaseFirestore firebaseFirestoreInstance;

  GroupTimetableFirestoreRepository(
      {required this.sharedPreferences, required this.firebaseFirestoreInstance});

  @override
  Future<Timetable> loadTimetableByReferenceId(
      String referenceId) async {
    SharedPreferences? prefs;
    await sharedPreferences.then((sharedPreferences) => prefs = sharedPreferences);

    Expirable<Map<String, dynamic>>? expirableTimetableJson;

    // if (prefs!.containsKey('timetable.group.my')) {
    //   Map<String, dynamic> json = jsonDecode(prefs!.getString('timetable')!);
    //   json['data'] = (json['data'] as Map<String, dynamic>);
    //
    //   expirableTimetableJson = (Expirable<Timetable.Timetable>.fromJson(json));
    //
    //   if (expirableTimetableJson.expireAt.isBefore(DateTime.now())) {
    //     expirableTimetableJson = null;
    //   }
    // }

    if (expirableTimetableJson == null) {
      Timetable timetable = Timetable.fromJson(
          (await FirebaseFirestore.instance.collection('timetable').get())
              .docs
              .map((doc) => doc.data()!)
              .first);

      List<TimetableItem> items = timetable.items
          .where((element) =>
              element.activity.groups.any((group) => group.id == referenceId))
          .toList();

      expirableTimetableJson = Expirable<Map<String, dynamic>>(
        duration: Duration(days: 30),
        data: Timetable(
            weekDetermination: timetable.weekDetermination,
            items: items,
            expiresAt: timetable.expiresAt).toJson() as Map<String, dynamic>,
      );

      prefs!.setString(
          'timetable.group.my', jsonEncode(expirableTimetableJson));
    }

    return Timetable.fromJson(expirableTimetableJson.data);
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() {
    return FirebaseFirestore.instance
        .collection('timetable_item_update')
        .get()
        .then((timetableItemUpdateListJson) =>
        timetableItemUpdateListJson.docs
            .map(
              (timetableItemUpdateJson) =>
              TimetableItemUpdate.fromJson(
                  timetableItemUpdateJson.data()!),
        )
            .toList());
  }
}
