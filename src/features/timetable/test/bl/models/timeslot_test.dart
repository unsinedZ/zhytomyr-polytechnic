import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('ClientProfile.fromJson work correctly', () {
    final Timeslot timeslot = Timeslot.fromJson(jsonDecode(
        '{"start" : "Start", "end" : "End"}'));

    expect(timeslot.start, "Start");
    expect(timeslot.end, "End");
  });
}
