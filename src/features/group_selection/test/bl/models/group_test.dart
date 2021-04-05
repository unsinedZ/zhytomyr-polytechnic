import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../lib/src/bl/models/group.dart';

void main() {
  test('ClientProfile.fromJson work correctly', () {
    final Group group = Group.fromJson(jsonDecode(
        '{"id" : "id", "name" : "Name", "year" : 3, "subgroups" : [{"id" : "id", "name" : "Name"}, {"id" : "id", "name" : "Name"}]}'));

    expect(group.id, "id");
    expect(group.name, "Name");
    expect(group.year, 3);
    expect(group.subgroups!.length, 2);
    expect(group.subgroups![0].name, 'Name');
    expect(group.subgroups![0].id, 'id');
  });
}
