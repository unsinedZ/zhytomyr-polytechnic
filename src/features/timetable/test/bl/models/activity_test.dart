import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/src/bl/models/models.dart';

void main() {
  test('Activity.fromJson work correctly', () {
    final Activity activity = Activity.fromJson(jsonDecode(
        '{'
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
        '}'
    ));

    expect(activity.id, 'id');
    expect(activity.name, 'Name');
    expect(activity.room, 'Room');

    expect(activity.tutor.name, 'Name');

    expect(activity.groups.length, 2);
    expect(activity.groups[0].id, "id");
    expect(activity.groups[0].name, "Name");
    expect(activity.groups[0].year, 3);
    expect(activity.groups[0].subgroups.length, 2);
    expect(activity.groups[0].subgroups[0].name, 'Name');
    expect(activity.groups[0].subgroups[0].id, 'id');

    expect(activity.time.start, 'Start');
    expect(activity.time.end, 'End');
  });
}
