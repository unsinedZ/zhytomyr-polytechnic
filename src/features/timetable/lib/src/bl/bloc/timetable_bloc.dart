import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/abstractions/group_repository.dart';
import 'package:timetable/src/bl/abstractions/tutor_repository.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableRepository timetableRepository;
  final GroupRepository groupRepository;
  final StreamSink<String> errorSink;
  final TutorRepository tutorRepository;

  TimetableBloc({
    required this.timetableRepository,
    required this.groupRepository,
    required this.errorSink,
    required this.tutorRepository,
  });

  final BehaviorSubject<Timetable?> _timetableSubject =
      BehaviorSubject<Timetable?>();

  final BehaviorSubject<Group?> _groupSubject = BehaviorSubject<Group?>();

  final BehaviorSubject<List<TimetableItemUpdate>?>
      _timetableItemUpdatesSubject =
      BehaviorSubject<List<TimetableItemUpdate>?>();

  final BehaviorSubject<Tutor?> _tutorSubject = BehaviorSubject<Tutor?>();

  Stream<Timetable?> get timetable => _timetableSubject.stream;

  Stream<Group?> get group => _groupSubject.stream;

  Stream<List<TimetableItemUpdate>?> get timetableItemUpdates =>
      _timetableItemUpdatesSubject.stream;

  Stream<Tutor?> get tutor => _tutorSubject.stream;

  void loadTimetable(int id, [String? groupId]) {
    _timetableSubject.add(null);

    timetableRepository
        .loadTimetableByReferenceId(id, groupId)
        .then((timetable) {
      _timetableSubject.add(timetable);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadGroup(int groupId) {
    _groupSubject.add(null);

    groupRepository.getGroupById(groupId).then((group) {
      _groupSubject.add(group);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadTimetableItemUpdates(int id) {
    _timetableItemUpdatesSubject.add(null);

    timetableRepository
        .getTimetableItemUpdates(id)
        .then((timetableItemUpdates) {
      _timetableItemUpdatesSubject.add(timetableItemUpdates);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadTutor(int tutorId) {
    _tutorSubject.add(null);

    tutorRepository.getTutorById(tutorId).then((tutor) {
      _tutorSubject.add(tutor);
    }).onError((error, _) {
      errorSink.add(error.toString());
    });
  }

  void dispose() {
    _timetableSubject.close();
    _groupSubject.close();
    _timetableItemUpdatesSubject.close();
    _tutorSubject.close();
  }
}
