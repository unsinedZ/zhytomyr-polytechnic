import '../models/models.dart';

abstract class GroupsLoader {
  Future<List<Group>> getGroups(int course, String facultyId);
}
