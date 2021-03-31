import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';


import '../../lib/src/models/models.dart';

void main() {
  test('ClientProfile.fromJson work correctly', () {
    final Subgroup group = Subgroup.fromJson(jsonDecode(
        '{"id" : "id", "name" : "Name"}'));

    expect(group.id, "id");
    expect(group.name, "Name");
  });
}