import 'package:googleapis_auth/auth_io.dart';

import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByReferenceId(int referenceId, AuthClient client);

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id, AuthClient client);

  Future<void> cancelLesson(Activity activity, DateTime dateTime, AuthClient client);

  Future<void> deleteTimetableUpdate(String id, AuthClient client);
}
