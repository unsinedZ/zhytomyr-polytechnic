import 'package:update_form/src/bl/models/group.dart';

extension DocumentExtensions on List<Group> {
  List<Group> divide() {
    return this.expand((group) {
      if (group.subgroups.length < 2) {
        return [group];
      }
      return group.subgroups.map((subgroup) {
        return Group(
          id: group.id,
          facultyId: group.facultyId,
          subgroups: [subgroup],
          year: group.year,
          name: group.name,
        );
      });
    }).toList();
  }

  List<Group> compose() {
    List<Group> groups = [];

    this.forEach((group) {
      if (groups.any((element) => element.id == group.id)) {
        int index = groups.indexWhere((element) => element.id == group.id);
        groups[index].subgroups.add(group.subgroups.first);
      } else {
        groups.add(group);
      }
    });

    return groups;
  }
}
