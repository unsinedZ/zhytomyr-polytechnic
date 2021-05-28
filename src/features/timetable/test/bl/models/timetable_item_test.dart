import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('TimetableItem.fromJson work correctly', () {
    final TimetableItem timetableItem = TimetableItem.fromJson(jsonDecode(
        '{"weekNumber" : 5, "dayNumber" : 5, "activity" : {'
            '"id" : "id", '
            '"name" : "Name", '
            '"tutor" : [{"id" : 0, "name" : "Name", "imageUrl" : "imageUrl"}], '
            '"room" : "Room", '
            '"groups" : ['
            '{'
            '"id" : 0, '
            '"name" : "Name", '
            '"facultyId" : 0, '
            '"year" : "3", '
            '"subgroups" : [{"id" : 0, "name" : "Name"}, {"id" : 0, "name" : "Name"}]'
            '}, '
            '{'
            '"id" : 0, '
            '"name" : "Name", '
            '"facultyId" : 0, '
            '"year" : "3", '
            '"subgroups" : [{"id" : 0, "name" : "Name"}, {"id" : 0, "name" : "Name"}]'
            '}'
            '], '
            '"time" : {"start" : "Start", "end" : "End"},'
            '"type": "type"'
            '}}'));

    expect(timetableItem.weekNumber, 5);
    expect(timetableItem.dayNumber, 5);
  });
}
