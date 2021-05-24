import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByKey(String key, [String? userGroupId]);

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates();
}
