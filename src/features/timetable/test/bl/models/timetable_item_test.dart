import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('TimetableItem.fromJson work correctly', () {
    final TimetableItem timetableItem = TimetableItem.fromJson(jsonDecode(
        '{"weekNumber" : 5, "dayNumber" : 5, "activity" : {'
            '"id" : "id", '
            '"name" : "Name", '
            '"tutor" : {"id" : "id", "name" : "Name", "imageUrl" : "imageUrl"}, '
            '"room" : "Room", '
            '"groups" : ['
            '{'
            '"id" : "id", '
            '"name" : "Name", '
            '"facultyId" : "facultyId", '
            '"year" : 3, '
            '"subgroups" : [{"id" : "id", "name" : "Name"}, {"id" : "id", "name" : "Name"}]'
            '}, '
            '{'
            '"id" : "id", '
            '"name" : "Name", '
            '"facultyId" : "facultyId", '
            '"year" : 3, '
            '"subgroups" : [{"id" : "id", "name" : "Name"}, {"id" : "id", "name" : "Name"}]'
            '}'
            '], '
            '"time" : {"start" : "Start", "end" : "End"}'
            '}}'));

    expect(timetableItem.weekNumber, 5);
    expect(timetableItem.dayNumber, 5);
  });
}
