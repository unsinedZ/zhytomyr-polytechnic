import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('Activity.fromJson work correctly', () {
    final Activity activity = Activity.fromJson(jsonDecode(
        '{'
            '"id" : "id", '
            '"name" : "Name", '
            '"tutors" : [{"id" : 0, "name" : "Name", "imageUrl" : "imageUrl"}], '
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
        '}'
    ));

    expect(activity.name, 'Name');
    expect(activity.room, 'Room');

    expect(activity.tutors.first.name, 'Name');

    expect(activity.groups.length, 2);
    expect(activity.groups[0].id, 0);
    expect(activity.groups[0].name, "Name");
    expect(activity.groups[0].year, '3');
    expect(activity.groups[0].subgroups.length, 2);
    expect(activity.groups[0].subgroups[0].name, 'Name');
    expect(activity.groups[0].subgroups[0].id, 0);

    expect(activity.time.start, 'Start');
    expect(activity.time.end, 'End');
  });
}
