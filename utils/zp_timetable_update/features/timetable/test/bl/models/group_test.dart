import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/group.dart';

void main() {
  test('Group.fromJson work correctly', () {
    final Group group = Group.fromJson(jsonDecode(
        '{"id" : 0, "facultyId" : 0, "name" : "Name", "year" : "3", "subgroups" : [{"id" : 0, "name" : "Name"}, {"id" : 0, "name" : "Name"}]}'));

    expect(group.id, 0);
    expect(group.name, "Name");
    expect(group.facultyId, 0);
    expect(group.year, "3");
    expect(group.subgroups.length, 2);
    expect(group.subgroups[0].name, 'Name');
    expect(group.subgroups[0].id, 0);
  });
}
