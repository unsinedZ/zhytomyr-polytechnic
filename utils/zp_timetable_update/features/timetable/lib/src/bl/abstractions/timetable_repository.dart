import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByReferenceId(int referenceId, [String? userGroupId]);

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id);

  Future<void> cancelLesson(Activity activity, DateTime dateTime);
}
