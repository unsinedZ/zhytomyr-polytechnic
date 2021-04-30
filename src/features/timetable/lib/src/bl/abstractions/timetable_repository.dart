import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetableByReferenceId(String referenceId, [String? userGroupId]);

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates();
}
