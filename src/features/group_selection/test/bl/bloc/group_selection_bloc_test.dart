import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:group_selection/src/bl/abstractions/groups_repository.dart';
import 'package:group_selection/src/bl/bloc/group_selection_bloc.dart';
import 'package:group_selection/src/bl/models/models.dart';

import 'package:mockito/mockito.dart';

class GroupsRepositoryMock extends Mock implements GroupsRepository {
  @override
  Future<List<Group>> getGroups(String? year, int? facultyId) =>
      super.noSuchMethod(Invocation.method(#getGroups, [year, facultyId]),
          returnValue: Future.value(<Group>[]));
}

void main() {
  test('GroupSelectionBloc.getGroups work correctly', () async {
    GroupsRepositoryMock groupsRepositoryMock = GroupsRepositoryMock();

    GroupSelectionBloc groupSelectionBloc = GroupSelectionBloc(
        groupsLoader: groupsRepositoryMock,
        errorSink: StreamController<String>().sink);

    when(groupsRepositoryMock.getGroups(any, any))
        .thenAnswer((_) => Future.value(<Group>[
              Group(name: 'SomeName', facultyId: 1, id: 0, year: '2'),
              Group(name: 'SomeName1', facultyId: 0, id: 1, year: '3'),
            ]));

    List<List<Group>?> results = <List<Group>?>[];

    groupSelectionBloc.groups.listen((groups) => results.add(groups));
    groupSelectionBloc.loadGroups('1', 0);

    await Future.delayed(const Duration());

    expect(results[0], null);
    expect(results[1]!.length, 2);
    expect(results[1]![0].name, 'SomeName');
    expect(results[1]![0].facultyId, '');
    expect(results[1]![0].id, '');
    expect(results[1]![0].year, 2);

    expect(results[1]![1].name, 'SomeName1');
    expect(results[1]![1].facultyId, '');
    expect(results[1]![1].id, '');
    expect(results[1]![1].year, 3);
  });
}
