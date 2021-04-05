import 'group.dart';
import 'timeslot.dart';
import 'tutor.dart';

class Activity {
  final String id;
  final String name;
  final Tutor tutor;
  final String room;
  final List<Group> groups;
  final Timeslot time;

  Activity({
    required this.id,
    required this.name,
    required this.tutor,
    required this.room,
    required this.groups,
    required this.time,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String,
        name: json['name'] as String,
        tutor: Tutor.fromJson(json['tutor']),
        room: json['room'] as String,
        groups: (json['groups'] as List<dynamic>)
            .map((groupJson) => Group.fromJson(groupJson))
            .toList(),
        time: Timeslot.fromJson(json['time']),
      );
}