import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('Timetable.fromJson work correctly', () {
    final Timetable timetable = Timetable.fromJson(jsonDecode(
        '{"timetableItems" : [], "expiresAt" : "expiresAt", "weekDetermination" : 0}'));

    expect(timetable.items!.length, 0);
    expect(timetable.expiresAt, "expiresAt");
    expect(timetable.weekDetermination, WeekDetermination.Odd);
  });
}
