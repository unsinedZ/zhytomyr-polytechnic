import 'package:timetable_screen/src/models/models.dart';

abstract class TimetableLoader {
  Future<Timetable> loadTimetable(WeekDetermination weekDetermination);
}