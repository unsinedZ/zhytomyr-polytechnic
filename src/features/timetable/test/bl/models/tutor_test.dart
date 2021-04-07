import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('Tutor.fromJson work correctly', () {
    final Tutor tutor = Tutor.fromJson(jsonDecode(
        '{"id" : "id", "name" : "Name", "imageUrl" : "imageUrl"}'));

    expect(tutor.id, "id");
    expect(tutor.name, "Name");
    expect(tutor.imageUrl, "imageUrl");
  });
}
