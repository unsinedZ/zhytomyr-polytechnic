import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:group_selection/src/bl/models/models.dart';

void main() {
  test('Group.fromJson work correctly', () {
    final Group group = Group.fromJson(jsonDecode(
        '{'
          '"id" : 1, '
          '"facultyId" : 1, '
          '"name" : "Name", "year" : "3", '
          '"subgroups" : ['
            '{"id" : 1, "name" : "Name"}, '
            '{"id" : 2, "name" : "Name"}'
          ']'
        '}'));

    expect(group.id, 1);
    expect(group.name, "Name");
    expect(group.facultyId, 1);
    expect(group.year, '3');
    expect(group.subgroups!.length, 2);
    expect(group.subgroups![0].name, 'Name');
    expect(group.subgroups![0].id, 1);
  });
}
