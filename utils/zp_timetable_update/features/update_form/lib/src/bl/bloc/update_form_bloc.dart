import 'dart:async';

import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:rxdart/rxdart.dart';

import 'package:update_form/src/bl/abstractions/groups_repository.dart';
import 'package:update_form/src/bl/abstractions/timetable_update_repository.dart';
import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/tutor.dart';

class UpdateFormBloc {
  final IGroupsRepository groupsRepository;
  final ITimetableUpdateRepository timetableUpdateRepository;
  final StreamSink<String> errorSink;

  UpdateFormBloc({
    required this.groupsRepository,
    required this.timetableUpdateRepository,
    required this.errorSink,
  });

  final BehaviorSubject<List<Group>> _groupsSubject =
      BehaviorSubject<List<Group>>();

  Stream<List<Group>> get groups => _groupsSubject.stream;

  void loadGroups(AuthClient client) {
    _groupsSubject.add([]);

    groupsRepository.getGroups(client).then((groups) {
      _groupsSubject.add(groups);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  // void loadTutor(AuthClient client) {
  //   _tutorController.add(null);
  //
  //   tutorRepository.getTutorById(tutorId, client).then((tutor) {
  //     _tutorController.add(tutor);
  //   }).onError((error, stack) {
  //     print(error);
  //     print(stack);
  //     errorSink.add(error.toString());
  //   });
  // }

  Future<void> createTimetableUpdate(
    AuthClient client,
    Document document,
    List<Group> groups,
    List<Tutor> tutors,
  ) async {
    timetableUpdateRepository
        .addTimetableUpdate(client, document, groups, tutors)
        .then((_) {})
        .onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void dispose() {
    _groupsSubject.close();
  }
}
