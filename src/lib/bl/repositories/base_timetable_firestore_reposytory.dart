import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/group_timetable_firestore_repository.dart';

class BaseTimetableFirestoreRepository {
  Future<Timetable> loadTimetable() async {
    Timetable timetable;

    timetable = Timetable.fromJson(
        (await FirebaseFirestore.instance.collection('timetable').get())
            .docs
            .map((doc) => doc.data()!)
            .first);

    return timetable;
  }
}

class TimetableFirestoreRepositoryFactory
    implements TimetableRepositoryFactory {
  @override
  TimetableRepository getTimetableRepository(
      TimetableType timetableType) {
    Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    switch (timetableType) {
      case TimetableType.Unspecified:
        return GroupTimetableFirestoreRepository(
            firebaseFirestoreInstance: firebaseFirestore,
            sharedPreferences: sharedPreferences);
      case TimetableType.Group:
        return GroupTimetableFirestoreRepository(
            firebaseFirestoreInstance: firebaseFirestore,
            sharedPreferences: sharedPreferences);
      case TimetableType.Teacher:
        return GroupTimetableFirestoreRepository(
            firebaseFirestoreInstance: firebaseFirestore,
            sharedPreferences: sharedPreferences);
    }
  }
}
