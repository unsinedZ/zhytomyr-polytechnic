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
        tutors: (json['tutor'] as List<dynamic>)
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
        'tutor': tutors.map((tutor) => tutor.toJson()).toList(),
        'room': room,
        'groups': groups.map((group) => group.toJson()).toList(),
        'time': time.toJson(),
        'type': type,
      };
}
