import 'dart:async';

import 'package:timetable/src/bl/abstractions/timetable_loader.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableLoader timetableLoader;

  StreamController<Timetable> _timetableController =
      StreamController();

  TimetableBloc({required this.timetableLoader});

  Stream<Timetable> get timetable => _timetableController.stream;

  void loadTimetable(WeekDetermination weekDetermination) =>
      timetableLoader
          .loadTimetable(weekDetermination).then((timetable) =>  _timetableController.add(timetable));

  void dispose() {
    _timetableController.close();
  }
}
