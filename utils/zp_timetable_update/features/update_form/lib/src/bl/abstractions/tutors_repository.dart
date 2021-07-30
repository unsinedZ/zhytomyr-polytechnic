import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/src/bl/models/group.dart';

abstract class ITutorsRepository {
  Future<List<Group>> getTutors(AuthClient client);
}