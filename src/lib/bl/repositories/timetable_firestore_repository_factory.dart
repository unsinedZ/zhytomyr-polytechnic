import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/group_timetable_firestore_repository.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/teacher_timetable_firestore_repository.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/unspecified_timetable_firestore_repository.dart';

class TimetableFirestoreRepositoryFactory
    implements TimetableRepositoryFactory {
  @override
  TimetableRepository getTimetableRepository(TimetableType timetableType) {
    Future<SharedPreferences> sharedPreferences =
        SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    switch (timetableType) {
      case TimetableType.Unspecified:
        return UnspecifiedTimetableFirestoreRepository();
      case TimetableType.Group:
        return GroupTimetableFirestoreRepository(
            firebaseFirestoreInstance: firebaseFirestore,
            sharedPreferences: sharedPreferences);
      case TimetableType.Teacher:
        return TeacherTimetableFirestoreRepository(
          firebaseFirestoreInstance: firebaseFirestore,
        );
    }
  }
}
