import 'subgroup.dart';

class Group {
  final int id;
  final String name;
  final String year;
  final int facultyId;
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
      id: json['id'] as int,
      name: json['name'] as String,
      year: json['year'] as String,
      facultyId: json['facultyId'] as int,
      subgroups: (json['subgroups'] as List<dynamic>)
          .map((order) => Subgroup.fromJson(order))
          .toList(),
    );
  }

  factory Group.fromObject(dynamic object) {
    return Group(
      id: object.id as int,
      name: object.name as String,
      year: object.year as String,
      facultyId: object.facultyId as int,
      subgroups: (object.subgroups as List<dynamic>)
          .map((subgroup) => Subgroup.fromObject(subgroup))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'year': year,
        'facultyId': facultyId,
        'subgroups': subgroups.map((subgroup) => subgroup.toJson()).toList(),
      };
}
