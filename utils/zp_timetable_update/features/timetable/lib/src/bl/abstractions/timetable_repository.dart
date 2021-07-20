import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByReferenceId(int referenceId);

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id);

  Future<void> cancelLesson(Activity activity, DateTime dateTime);
}
