import 'group.dart';
import 'timeslot.dart';
import 'tutor.dart';

class Activity {
  final int id;
  final String name;
  final List<Tutor> tutors;
  final String room;
  final List<Group> groups;
  final Timeslot time;

  Activity({
    required this.id,
    required this.name,
    required this.tutors,
    required this.room,
    required this.groups,
    required this.time,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as int,
        name: json['name'] as String,
        tutors: (json['tutor'] as List<dynamic>)
            .map((tutorJson) => Tutor.fromJson(tutorJson))
            .toList(),
        room: json['room'] as String,
        groups: (json['groups'] as List<dynamic>)
            .map((groupJson) => Group.fromJson(groupJson))
            .toList(),
        time: Timeslot.fromJson(json['time']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'tutors': tutors.map((tutor) => tutor.toJson()).toList(),
    'room': room,
    'groups': groups.map((group) => group.toJson()).toList(),
    'time': time.toJson(),
  };
}
