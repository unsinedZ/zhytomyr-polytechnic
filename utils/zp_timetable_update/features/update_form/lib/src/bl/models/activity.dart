import 'package:googleapis/firestore/v1.dart';

import 'group.dart';
import 'timeslot.dart';
import 'tutor.dart';

class Activity {
  final String name;
  final List<Tutor> tutors;
  final String room;
  final List<Group> groups;
  final Timeslot time;
  final String type;

  Activity({
    required this.name,
    required this.tutors,
    required this.room,
    required this.groups,
    required this.time,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json['name'] as String,
        tutors: (json['tutors'] as List<dynamic>)
            .map((tutorJson) => Tutor.fromJson(tutorJson))
            .toList(),
        room: json['room'] as String,
        groups: (json['groups'] as List<dynamic>)
            .map((groupJson) => Group.fromJson(groupJson))
            .toList(),
        time: Timeslot.fromJson(json['time']),
        type: json['type'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'tutors': tutors.map((tutor) => tutor.toJson()).toList(),
        'room': room,
        'groups': groups.map((group) => group.toJson()).toList(),
        'time': time.toJson(),
        'type': type,
      };

  MapValue toMapValue() {
    MapValue timeMapValue = MapValue();

    timeMapValue.fields = {
      'start': Value()..stringValue = time.start,
      'end': Value()..stringValue = time.end,
    };

    ArrayValue groupsArrayValue = ArrayValue();
    groupsArrayValue.values = groups.map((group) {
      Value groupValue = Value();

      groupValue.mapValue = group.toMapValue();

      return groupValue;
    }).toList();

    ArrayValue tutorsArrayValue = ArrayValue();
    tutorsArrayValue.values = tutors.map((tutor) {
      Value tutorValue = Value();

      tutorValue.mapValue = tutor.toMapValue();

      return tutorValue;
    }).toList();

    MapValue activityMapValue = MapValue();

    activityMapValue.fields = {
      'name': Value()..stringValue = name,
      'room': Value()..stringValue = room,
      'type': Value()..stringValue = type,
      'time': Value()..mapValue = timeMapValue,
      'groups': Value()..arrayValue = groupsArrayValue,
      'tutors': Value()..arrayValue = tutorsArrayValue,
    };

    return activityMapValue;
  }
}
