import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/abstractions/tutor_repository.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableRepository timetableRepository;
  final StreamSink<String> errorSink;
  final TutorRepository tutorRepository;

  TimetableBloc({
    required this.timetableRepository,
    required this.errorSink,
    required this.tutorRepository,
  });

  final BehaviorSubject<Timetable?> _timetableController =
      BehaviorSubject<Timetable?>();

  final BehaviorSubject<List<TimetableItemUpdate>?>
      _timetableItemUpdatesController =
      BehaviorSubject<List<TimetableItemUpdate>?>();

  final BehaviorSubject<Tutor?> _tutorController = BehaviorSubject<Tutor?>();

  Stream<Timetable?> get timetable => _timetableController.stream;

  Stream<List<TimetableItemUpdate>?> get timetableItemUpdates =>
      _timetableItemUpdatesController.stream;

  Stream<Tutor?> get tutor => _tutorController.stream;

  void loadTimetable() {
    _timetableController.add(null);

    timetableRepository
        .loadTimetableByReferenceId()
        .then((timetable) {
      _timetableController.add(timetable);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadTimetableItemUpdates() {
    _timetableItemUpdatesController.add(null);

    timetableRepository
        .getTimetableItemUpdates()
        .then((timetableItemUpdates) {
      _timetableItemUpdatesController.add(timetableItemUpdates);
      print(timetableItemUpdates.length.toString() +
          ' - timetableItemUpdates.length');
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      errorSink.add(error.toString());
    });
  }

  void loadTutor() {
    _tutorController.add(null);

    tutorRepository.getTutorById().then((tutor) {
      _tutorController.add(tutor);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void showUpdateForm() {

  }

  void cancelLesson(
      Activity activity, DateTime dateTime) {
    timetableRepository
        .cancelLesson(activity, dateTime)
        .then((_) => loadTimetableItemUpdates())
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      errorSink.add(error.toString());
    });
  }

  void deleteTimetableUpdate(String id) {
    timetableRepository
        .deleteTimetableUpdate(id)
        .then((_) => loadTimetableItemUpdates())
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      errorSink.add(error.toString());
    });
  }

  void dispose() {
    _timetableController.close();
    _timetableItemUpdatesController.close();
    _tutorController.close();
  }
}
