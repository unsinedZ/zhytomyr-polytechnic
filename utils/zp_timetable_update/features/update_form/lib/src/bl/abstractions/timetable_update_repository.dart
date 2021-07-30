import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/tutor.dart';

abstract class ITimetableUpdateRepository {
  Future<void> addTimetableUpdate(
    AuthClient client,
    Document document,
    List<Group> groups,
    List<Tutor> tutors,
  );
}
