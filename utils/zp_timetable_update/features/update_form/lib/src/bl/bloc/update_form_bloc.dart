import 'dart:async';

import 'package:googleapis_auth/auth_io.dart';
import 'package:rxdart/rxdart.dart';

import 'package:update_form/src/bl/abstractions/groups_repository.dart';
import 'package:update_form/src/bl/abstractions/timetable_update_repository.dart';
import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/timetable_item_update.dart';

class UpdateFormBloc {
  final IGroupsRepository groupsRepository;
  final ITimetableUpdateRepository timetableUpdateRepository;
  final StreamSink<String> errorSink;

  UpdateFormBloc({
    required this.groupsRepository,
    required this.timetableUpdateRepository,
    required this.errorSink,
  });

  List<Group> selectedGroupsList = [];

  final BehaviorSubject<List<Group>> _groupsSubject =
      BehaviorSubject<List<Group>>();

  final BehaviorSubject<List<Group>> _selectedGroupsSubject =
      BehaviorSubject<List<Group>>();

  final BehaviorSubject<bool> _isUpdateCreatingSubject =
  BehaviorSubject<bool>();

  Stream<List<Group>> get groups => _groupsSubject.stream;

  Stream<List<Group>> get selectedGroups => _selectedGroupsSubject.stream;

  Stream<bool> get isUpdateCreating => _isUpdateCreatingSubject.stream;

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

  void setSelectedGroups(List<Group> groups) {
    selectedGroupsList = groups;
    _selectedGroupsSubject.add(selectedGroupsList);
  }

  void removeFromSelectedGroup(Group group) {
    selectedGroupsList.remove(group);
    _selectedGroupsSubject.add(selectedGroupsList);
  }

  Future<void> createTimetableUpdate(
    AuthClient client,
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
  ) async {
    _isUpdateCreatingSubject.add(true);
    await timetableUpdateRepository
        .addTimetableUpdate(client, timetableItemUpdate, groups, initialGroups)
        .then((_) {})
        .onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
    _isUpdateCreatingSubject.add(false);
  }

  void dispose() {
    _groupsSubject.close();
    _selectedGroupsSubject.close();
    _isUpdateCreatingSubject.close();
  }
}
