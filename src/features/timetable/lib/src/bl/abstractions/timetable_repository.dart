import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableRepository {
  Future<Timetable> loadTimetable();

  Future<Group> getGroupById(String groupId);

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates();
}