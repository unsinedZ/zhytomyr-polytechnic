import 'dart:async';

import 'package:group_selection/src/bl/abstractions/groups_repository.dart';
import 'package:group_selection/src/bl/models/models.dart';

class GroupSelectionBloc {
  final GroupsRepository groupsLoader;
  final StreamSink<String> errorSink;

  StreamController<List<Group>?> _groupsController =
      StreamController.broadcast();

  GroupSelectionBloc({
    required this.groupsLoader,
    required this.errorSink,
  });

  Stream<List<Group>?> get groups => _groupsController.stream;

  void loadGroups(String year, int faculty) async {
    _groupsController.add(null);
    try {
      _groupsController.add(await groupsLoader.getGroups(year, faculty));
    } catch (err, stack) {
      print(err);
      print(stack);
      errorSink.add(err.toString());
      _groupsController.add([]);
    }
  }

  void dispose() {
    _groupsController.close();
  }
}
