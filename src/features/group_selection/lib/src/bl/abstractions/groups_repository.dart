import '../models/models.dart';

abstract class GroupsRepository {
  Future<List<Group>> getGroups(int course, String facultyId);

  Future<void> saveUserGroup(String userId, String groupId, String subgroupId);
} // TODO UserRepository
