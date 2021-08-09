import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByReferenceId();

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates();

  Future<void> cancelLesson(Activity activity, DateTime dateTime);

  Future<void> deleteTimetableUpdate(String id);
}
