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

  GroupTimetableFirestoreRepository(
      {required this.sharedPreferences,
      required this.firebaseFirestoreInstance});

  @override
  Future<Timetable> loadTimetableByReferenceId(String referenceId) async {
    late SharedPreferences prefs;
    await sharedPreferences
        .then((sharedPreferences) => prefs = sharedPreferences);

    String? userGroupId = prefs.getString('userGroup');
    Timetable? timetable;

    if (prefs.containsKey('timetable.group.my') && userGroupId == referenceId) {
      Map<String, dynamic> json = jsonDecode(prefs.getString('timetable')!);
      json['data'] = (json['data'] as Map<String, dynamic>);

      Expirable<Map<String, dynamic>> expirableTimetableJson = (Expirable<Map<String, dynamic>>.fromJson(json));

      if (expirableTimetableJson.expireAt.isAfter(DateTime.now())) {
        timetable = Timetable.fromJson(expirableTimetableJson.data);
      }
    }

    if (timetable == null) {
      Timetable timetable = Timetable.fromJson(
          (await firebaseFirestoreInstance.collection('timetable').get())
              .docs
              .map((doc) => doc.data()!)
              .first);

      List<TimetableItem> items = timetable.items
          .where((element) =>
              element.activity.groups.any((group) => group.id == referenceId))
          .toList();

      timetable = Timetable(
        weekDetermination: timetable.weekDetermination,
        items: items,
        expiresAt: timetable.expiresAt,
      );

      if(userGroupId == referenceId) {
        Expirable<Map<String, dynamic>> expirableTimetableJson = Expirable<Map<String, dynamic>>(
          duration: Duration(days: 30),
          data: timetable.toJson(),
        );

        prefs.setString(
            'timetable.group.my', jsonEncode(expirableTimetableJson));
      }
    }

    return timetable!;
  }
}