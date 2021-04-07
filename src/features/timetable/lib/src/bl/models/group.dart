import 'subgroup.dart';

class Group {
  final String id;
  final String name;
  final int year;
  final String facultyId;
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
      id: json['id'] as String,
      name: json['name'] as String,
      year: json['year'] as int,
      facultyId: json['facultyId'] as String,
      subgroups: (json['subgroups'] as List<dynamic>)
          .map((order) => Subgroup.fromJson(order))
          .toList(),
    );
  }
}
