import 'subgroup.dart';

class Group {
  final int id;
  final String name;
  final String year;
  final int facultyId;
  final List<Subgroup>? subgroups;

  Group({
    required this.id,
    required this.name,
    required this.year,
    required this.facultyId,
    this.subgroups,
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
}
