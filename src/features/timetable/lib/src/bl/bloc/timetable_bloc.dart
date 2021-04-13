import 'dart:async';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableRepository timetableRepository;
  final StreamSink<String> errorSink;

  final StreamController<Timetable?> _timetableController = StreamController.broadcast();
  final StreamController<Group?> _groupController = StreamController.broadcast();

  TimetableBloc({
    required this.timetableRepository,
    required this.errorSink,
  });

  Stream<Timetable?> get timetable => _timetableController.stream;

  Stream<Group?> get group => _groupController.stream;

  void loadTimetable() {
    _timetableController.add(null);

    timetableRepository
        .loadTimetable()
        .then((timetable) => _timetableController.add(timetable))
        .onError((error, stackTrace) => errorSink.add(error.toString()));
  }

  void loadGroup(String groupId) {
    _groupController.add(null);

    timetableRepository
        .getGroupById(groupId)
        .then((group) => _groupController.add(group))
        .onError((error, stackTrace) => errorSink.add(error.toString()));
  }

  void dispose() {
    _timetableController.close();
    _groupController.close();
  }
}
