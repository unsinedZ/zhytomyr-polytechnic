import '../models/models.dart';

abstract class GroupsRepository {
  Future<List<Group>> getGroups(String year, int facultyId);
}
