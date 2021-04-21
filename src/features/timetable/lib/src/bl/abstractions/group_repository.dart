import 'package:timetable/src/bl/models/models.dart';

abstract class GroupRepository {
  Future<Group> getGroupById(String groupId);
}