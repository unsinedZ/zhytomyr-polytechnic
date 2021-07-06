import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:group_selection/src/bl/models/models.dart';

void main() {
  test('Subgroup.fromJson work correctly', () {
    final Subgroup group = Subgroup.fromJson(jsonDecode(
        '{"id" : 1, "name" : "Name"}'));

    expect(group.id, 1);
    expect(group.name, "Name");
  });
}