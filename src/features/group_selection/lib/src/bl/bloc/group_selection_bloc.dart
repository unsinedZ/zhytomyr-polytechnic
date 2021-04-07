import 'dart:async';

import 'package:group_selection/src/bl/abstractions/groups_loader.dart';
import 'package:group_selection/src/bl/models/models.dart';

class GroupSelectionBloc {
  final GroupsLoader groupsLoader;

  StreamController<List<Group>?> _groupsController =
      StreamController.broadcast();

  GroupSelectionBloc({required this.groupsLoader});

  Stream<List<Group>?> get groups => _groupsController.stream;

  void loadGroups(int course, String faculty) async {
    _groupsController.add(null);

    _groupsController.add(await groupsLoader.getGroups(course, faculty));
  }

  void dispose() {
    _groupsController.close();
  }
}
