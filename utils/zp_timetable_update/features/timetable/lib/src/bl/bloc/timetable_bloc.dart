import 'dart:async';

import 'package:googleapis_auth/auth_io.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/abstractions/tutor_repository.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableRepository timetableRepository;
  final StreamSink<String> errorSink;
  final TutorRepository tutorRepository;
  final int tutorId;

  TimetableBloc({
    required this.timetableRepository,
    required this.errorSink,
    required this.tutorRepository,
    required this.tutorId,
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
        .loadTimetableByReferenceId(tutorId)
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
        .getTimetableItemUpdates(tutorId)
        .then((timetableItemUpdates) {
      _timetableItemUpdatesController.add(timetableItemUpdates);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadTutor(AuthClient client) {
    _tutorController.add(null);

    tutorRepository.getTutorById(tutorId, client).then((tutor) {
      _tutorController.add(tutor);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  Future<void> cancelLesson(Activity activity, DateTime dateTime) async {
    await timetableRepository
        .cancelLesson(activity, dateTime)
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      errorSink.add(error.toString());
    });
    return null;
  }

  void dispose() {
    _timetableController.close();
    _timetableItemUpdatesController.close();
    _tutorController.close();
  }
}
