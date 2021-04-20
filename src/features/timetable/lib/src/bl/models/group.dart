import 'subgroup.dart';

class Group {
  final String id;
  final String name;
  final int year;
  final String facultyId;
  final List<Subgroup> subgroups;

  Group({
    required this.id,
    required this.name,
    required this.year,
    required this.facultyId,
    required this.subgroups,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      year: json['year'] as int,
      facultyId: json['facultyId'] as String,
      subgroups: (json['subgroups'] as List<dynamic>)
          .map((subgroup) => Subgroup.fromJson(subgroup))
          .toList(),
    );
  }

  factory Group.fromObject(dynamic object) {
    return Group(id: object.id as String,
      name: object.name as String,
      year: object.year as int,
      facultyId: object.facultyId as String,
      subgroups: (object.subgroups as List<dynamic>)
          .map((subgroup) => Subgroup.fromObject(subgroup))
          .toList(),);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'year': year,
    'facultyId': facultyId,
    'subgroups': subgroups.map((subgroup) => subgroup.toJson()).toList(),
  };
}
