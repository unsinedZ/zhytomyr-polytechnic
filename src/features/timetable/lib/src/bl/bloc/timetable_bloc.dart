import 'dart:async';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/abstractions/group_repository.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableRepository timetableRepository;
  final GroupRepository groupRepository;
  final StreamSink<String> errorSink;

  final StreamController<Timetable?> _timetableController =
      StreamController.broadcast();
  final StreamController<Group?> _groupController =
      StreamController.broadcast();
  final StreamController<List<TimetableItemUpdate>?>
      _timetableItemUpdatesController = StreamController.broadcast();

  TimetableBloc({
    required this.timetableRepository,
    required this.groupRepository,
    required this.errorSink,
  });

  Stream<Timetable?> get timetable => _timetableController.stream;

  Stream<Group?> get group => _groupController.stream;

  Stream<List<TimetableItemUpdate>?> get timetableItemUpdates =>
      _timetableItemUpdatesController.stream;

  void loadTimetable(String id) {
    _timetableController.add(null);

    timetableRepository
        .loadTimetableByReferenceId(id)
        .then((timetable) => _timetableController.add(timetable))
        .onError((error, _) => errorSink.add(error.toString()));
  }

  void loadGroup(String groupId) {
    _groupController.add(null);

    groupRepository
        .getGroupById(groupId)
        .then((group) => _groupController.add(group))
        .onError((error, _) => errorSink.add(error.toString()));
  }

  void loadTimetableItemUpdates() {
    _timetableItemUpdatesController.add(null);

    timetableRepository
        .getTimetableItemUpdates()
        .then((timetableItemUpdates) =>
            _timetableItemUpdatesController.add(timetableItemUpdates))
        .onError((error, _) => errorSink.add(error.toString()));
  }

  void dispose() {
    _timetableController.close();
    _groupController.close();
    _timetableItemUpdatesController.close();
  }
}
