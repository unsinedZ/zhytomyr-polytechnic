import '../models/models.dart';

abstract class FirebaseGroupsLoader {
  Future<List<Group>> getGroups(int course);
}
