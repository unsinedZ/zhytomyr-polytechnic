import 'package:timetable/src/bl/models/models.dart';

abstract class TimetableLoader {
  Future<Timetable> loadTimetable();
}