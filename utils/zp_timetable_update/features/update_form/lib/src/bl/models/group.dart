import 'package:googleapis/firestore/v1.dart';

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
      id: int.parse(json['id']),
      name: json['name'] as String,
      year: json['year'] as String,
      facultyId: int.parse(json['facultyId']),
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
        'id': id.toString(),
        'name': name,
        'year': year,
        'facultyId': facultyId.toString(),
        'subgroups': subgroups.map((subgroup) => subgroup.toJson()).toList(),
      };

  MapValue toMapValue() {
    ArrayValue subgroupsArrayValue = ArrayValue();

    subgroupsArrayValue.values = subgroups.map((subgroup) {
      Value subgroupValue = Value();

      MapValue subgroupMapValue = MapValue();
      subgroupMapValue.fields = {
        'id': Value()..integerValue = subgroup.id.toString(),
        'name': Value()..stringValue = subgroup.name,
      };

      subgroupValue.mapValue = subgroupMapValue;
      return subgroupValue;
    }).toList();

    MapValue groupMapValue = MapValue();

    groupMapValue.fields = {
      'facultyId': Value()..integerValue = facultyId.toString(),
      'id': Value()..integerValue = id.toString(),
      'name': Value()..stringValue = name,
      'year': Value()..stringValue = year,
      'subgroups': Value()..arrayValue = subgroupsArrayValue,
    };

    return groupMapValue;
  }

  @override
  String toString() {
    String groupString = id.toString();

    if(subgroups.isNotEmpty) {
      groupString = groupString + '/' + subgroups.first.name;
    }

    return groupString;
  }

  @override
  bool operator ==(other) {
    return this.toString() == other.toString();
  }

  @override
  int get hashCode => super.hashCode;

}