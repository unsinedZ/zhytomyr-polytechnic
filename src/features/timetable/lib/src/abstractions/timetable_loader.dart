import 'package:timetable/src/models/models.dart';

abstract class TimetableLoader {
  Future<Timetable> loadTimetable(WeekDetermination weekDetermination);
}