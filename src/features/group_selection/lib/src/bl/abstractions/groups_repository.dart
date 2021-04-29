import '../models/models.dart';

abstract class GroupsRepository {
  Future<List<Group>> getGroups(int course, String facultyId);
}
