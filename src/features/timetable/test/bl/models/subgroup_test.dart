import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/subgroup.dart';

void main() {
  test('Subgroup.fromJson work correctly', () {
    final Subgroup group = Subgroup.fromJson(jsonDecode(
        '{"id" : 0, "name" : "Name"}'));

    expect(group.id, 0);
    expect(group.name, "Name");
  });
}