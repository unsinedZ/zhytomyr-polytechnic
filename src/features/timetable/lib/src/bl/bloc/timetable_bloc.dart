import 'dart:async';

import 'package:timetable/src/bl/abstractions/timetable_loader.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableLoader timetableLoader;
  final StreamSink<String> errorSink;

  StreamController<Timetable?> _timetableController = StreamController();

  TimetableBloc({
    required this.timetableLoader,
    required this.errorSink,
  });

  Stream<Timetable?> get timetable => _timetableController.stream;

  void loadTimetable(WeekDetermination weekDetermination) {
    _timetableController.add(null);

    timetableLoader
        .loadTimetable(weekDetermination)
        .then((timetable) => _timetableController.add(timetable));
  }

  void dispose() {
    _timetableController.close();
  }
}
