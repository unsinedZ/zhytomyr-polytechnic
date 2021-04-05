import 'package:flutter_test/flutter_test.dart';
import 'package:group_selection/group_selection.dart';
import 'package:group_selection/src/bl/bloc/group_selection_bloc.dart';

import 'package:mockito/mockito.dart';

class GroupsLoaderMock extends Mock implements GroupsLoader {
  @override
  Future<List<Group>> getGroups(int? course, String? facultyId) =>
      super.noSuchMethod(Invocation.method(#getGroups, [course, facultyId]),
          returnValue: Future.value(<Group>[]));
}

void main() {
  test('GroupSelectionBloc.getGroups work correctly', () async {
    GroupsLoaderMock groupsLoaderMock = GroupsLoaderMock();

    GroupSelectionBloc groupSelectionBloc =
        GroupSelectionBloc(groupsLoader: groupsLoaderMock);

    when(groupsLoaderMock.getGroups(any, any)).thenAnswer((_) => Future.value(
        <Group>[Group(name: 'SomeName'), Group(name: 'SomeName1')]));

    List<List<Group>?> results = <List<Group>?>[];

    groupSelectionBloc.groups.listen((groups) => results.add(groups));
    groupSelectionBloc.loadGroups(1, 'facultyId');

    await Future.delayed(const Duration());

    expect(results[0], null);
    expect(results[1]!.length, 2);
    expect(results[1]![0].name, 'SomeName');
    expect(results[1]![1].name, 'SomeName1');
  });
}
