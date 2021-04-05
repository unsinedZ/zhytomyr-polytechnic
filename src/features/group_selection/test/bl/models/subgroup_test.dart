import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../../lib/src/bl/models/models.dart';

void main() {
  test('Subgroup.fromJson work correctly', () {
    final Subgroup group = Subgroup.fromJson(jsonDecode(
        '{"id" : "id", "name" : "Name"}'));

    expect(group.id, "id");
    expect(group.name, "Name");
  });
}