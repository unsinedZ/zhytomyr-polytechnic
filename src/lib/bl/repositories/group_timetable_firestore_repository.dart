import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/base_timetable_firestore_repository.dart';

class GroupTimetableFirestoreRepository extends BaseTimetableFirestoreRepository
    implements TimetableRepository {
  final Future<SharedPreferences> sharedPreferences;
  final FirebaseFirestore firebaseFirestoreInstance;

  GroupTimetableFirestoreRepository(
      {required this.sharedPreferences,
      required this.firebaseFirestoreInstance});

  @override
  Future<Timetable> loadTimetableByReferenceId(String referenceId) async =>
      Timetable.fromJson(
          (await firebaseFirestoreInstance.collection('timetable').get())
              .docs
              .map((doc) => doc.data()!)
              .first);
}
