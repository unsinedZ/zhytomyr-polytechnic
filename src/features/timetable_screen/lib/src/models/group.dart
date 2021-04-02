import 'subgroup.dart';

class Group {
  Group({
    this.id,
    this.name,
    this.year,
    this.facultyId,
    this.subgroups,
  });

  String? id;
  String? name;
  int? year;
  String? facultyId;
  List<Subgroup>? subgroups;

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
