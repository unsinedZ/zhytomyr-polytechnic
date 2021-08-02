import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/tutor.dart';

abstract class ITimetableUpdateRepository {
  Future<void> addTimetableUpdate(
    AuthClient client,
    List<Document> documents,
    List<Group> groups,
  );
}
