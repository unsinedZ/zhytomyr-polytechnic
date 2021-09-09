import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:update_form/src/bl/abstractions/groups_repository.dart';
import 'package:update_form/src/bl/abstractions/timetable_update_repository.dart';
import 'package:update_form/src/bl/models/activity_name.dart';
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

  final BehaviorSubject<List<Group>> _groupsSubject =
      BehaviorSubject<List<Group>>();

  final BehaviorSubject<List<Group>> _selectedGroupsSubject =
      BehaviorSubject<List<Group>>();

  final BehaviorSubject<List<ActivityName>?> _activityNamesSubject =
      BehaviorSubject<List<ActivityName>?>();

  final StreamController<bool> _isUpdateCreatingSubject =
      StreamController<bool>.broadcast();

  final StreamController<void> _onUpdateCreatedController =
      StreamController<void>();

  Stream<List<Group>> get groups => _groupsSubject.stream;

  Stream<List<ActivityName>?> get activityNames => _activityNamesSubject.stream;

  ValueStream<List<Group>> get selectedGroups => _selectedGroupsSubject.stream;

  Stream<bool> get isUpdateCreating => _isUpdateCreatingSubject.stream;

  Stream<void> get onUpdateCreated => _onUpdateCreatedController.stream;

  void loadGroups() {
    _groupsSubject.add([]);

    groupsRepository.getGroups().then((groups) {
      _groupsSubject.add(groups);
    }).onError((error, stack) {
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void loadActivityNames() {
    _activityNamesSubject.add(null);

    timetableUpdateRepository.loadSubjectNames().then((subjectNames) {
      print(subjectNames.length);
      _activityNamesSubject.add(subjectNames);
    }).onError((error, stack) {
      _activityNamesSubject.add([]);
      print(error);
      print(stack);
      errorSink.add(error.toString());
    });
  }

  void setSelectedGroups(List<Group> groups) {
    _selectedGroupsSubject.add(groups);
  }

  void removeFromSelectedGroup(Group group) {
    List<Group> selectedGroupsList = selectedGroups.value;
    selectedGroupsList.remove(group);
    _selectedGroupsSubject.add(selectedGroupsList);
  }

  Future<void> createTimetableUpdate(
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
  ) async {
    _isUpdateCreatingSubject.add(true);
    await timetableUpdateRepository
        .addTimetableUpdate(timetableItemUpdate, groups, initialGroups)
        .then((_) {
      _onUpdateCreatedController.add(null);
    }).onError((error, stack) {
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
    _onUpdateCreatedController.close();
    _activityNamesSubject.close();
  }
}
