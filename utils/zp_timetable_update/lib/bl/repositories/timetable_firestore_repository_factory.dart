import 'package:authorization_bloc/authorization_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart';
import 'package:zp_timetable_update/bl/repositories/group_timetable_firestore_repository.dart';
import 'package:zp_timetable_update/bl/repositories/tutor_timetable_firestore_repository.dart';

class TimetableFirestoreRepositoryFactory
    implements TimetableRepositoryFactory {
  @override
  TimetableRepository getTimetableRepository(TimetableType timetableType, AuthClient client) {
    Future<SharedPreferences> sharedPreferences =
        SharedPreferences.getInstance();

    switch (timetableType) { // TODO
      case TimetableType.Unspecified:
        return TutorTimetableFirestoreRepository(
          client: client,
            sharedPreferences: sharedPreferences);
      case TimetableType.Tutor:
        return TutorTimetableFirestoreRepository(
            client: client,
            sharedPreferences: sharedPreferences);
    }
  }
}
