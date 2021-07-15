import 'dart:async';

import 'package:googleapis_auth/auth_io.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/abstractions/group_repository.dart';
import 'package:timetable/src/bl/abstractions/tutor_repository.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableBloc {
  final TimetableRepository timetableRepository;

  //final GroupRepository groupRepository;
  final StreamSink<String> errorSink;
  final TutorRepository tutorRepository;

  TimetableBloc({
    required this.timetableRepository,
    //required this.groupRepository,
    required this.errorSink,
    required this.tutorRepository,
  });

  final BehaviorSubject<Timetable?> _timetableController =
      BehaviorSubject<Timetable?>();

  // final BehaviorSubject<Group?> _groupController = BehaviorSubject<Group?>();
  final BehaviorSubject<List<TimetableItemUpdate>?>
      _timetableItemUpdatesController =
      BehaviorSubject<List<TimetableItemUpdate>?>();
  final BehaviorSubject<Tutor?> _tutorController = BehaviorSubject<Tutor?>();

  Stream<Timetable?> get timetable => _timetableController.stream;

  // Stream<Group?> get group => _groupController.stream;

  Stream<List<TimetableItemUpdate>?> get timetableItemUpdates =>
      _timetableItemUpdatesController.stream;

  Stream<Tutor?> get tutor => _tutorController.stream;

  void loadTimetable(int id, [String? groupId]) {
    _timetableController.add(null);

    timetableRepository
        .loadTimetableByReferenceId(id, groupId)
        .then((timetable) {
      _timetableController.add(timetable);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  // void loadGroup(int groupId) {
  //   _groupController.add(null);
  //
  //   groupRepository.getGroupById(groupId).then((group) {
  //     _groupController.add(group);
  //   }).onError((error, stack) {
  //     print(error);
  //     print(stack);
  //     errorSink.add(error.toString());
  //   });
  // }

  void loadTimetableItemUpdates(int id) {
    _timetableItemUpdatesController.add(null);

    timetableRepository
        .getTimetableItemUpdates(id)
        .then((timetableItemUpdates) {
      _timetableItemUpdatesController.add(timetableItemUpdates);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadTutor(int tutorId, AuthClient client) {
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
    print('cancelLesson');
    await timetableRepository
        .cancelLesson(activity, dateTime)
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      errorSink.add(error.toString());
    });
    print('cancelLesson1');
    return null;
  }

  void dispose() {
    _timetableController.close();
    _timetableItemUpdatesController.close();
    _tutorController.close();
  }
}
