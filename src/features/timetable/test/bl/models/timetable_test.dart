import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('Timetable.fromJson work correctly', () {
    final Timetable timetable = Timetable.fromJson(jsonDecode(
        '{"items" : [], "timetableData" : {'
              '"id": "0",'
              '"enabled": 1,'
              '"expiredAt": 1,'
              '"lastModified": 1,'
              '"weekDetermination": 1'
            '}'
          '}'));

    expect(timetable.items.length, 0);
    // expect(timetable.expiresAt, "expiresAt");
    // expect(timetable.weekDetermination, WeekDetermination.Odd);
  });
}
