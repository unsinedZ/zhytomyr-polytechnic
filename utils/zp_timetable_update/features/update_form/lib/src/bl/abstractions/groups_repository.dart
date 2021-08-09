import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/src/bl/models/group.dart';

abstract class IGroupsRepository {
  Future<List<Group>> getGroups();
}