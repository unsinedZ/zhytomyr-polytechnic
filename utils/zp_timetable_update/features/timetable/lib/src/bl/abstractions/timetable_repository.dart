import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByReferenceId();

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates();

  Future<void> cancelLesson(
    Activity activity,
    DateTime dateTime,
    int weekNumber,
    int dayNumber,
  );

  Future<void> deleteTimetableUpdate(
    String id,
    int weekNumber,
    int dayNumber,
  );
}
