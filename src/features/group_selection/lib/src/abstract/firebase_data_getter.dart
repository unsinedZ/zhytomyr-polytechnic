import '../models/models.dart';

abstract class FirebaseDataGetter {
  Future<List<Group>> getGroups(int course);
}

class FirebaseDataGetterMock implements FirebaseDataGetter {
  Future<List<Group>> getGroups(int course) => Future.delayed(
      Duration(seconds: 1),
      () => [
            Group(name: 'group_1_' + course.toString()),
            Group(name: 'group_2_' + course.toString()),
            Group(name: 'group_3_' + course.toString()),
            Group(
              name: 'group_4_' + course.toString(),
              subgroups: [
                Subgroup(
                  name: 'subgroup_1_' + course.toString(),
                ),
                Subgroup(
                  name: 'subgroup_2_' + course.toString(),
                ),
                Subgroup(
                  name: 'subgroup_3_' + course.toString(),
                ),
                Subgroup(
                  name: 'subgroup_4_' + course.toString(),
                ),
              ],
            ),
            Group(name: 'group_5_' + course.toString()),
          ]);
}
