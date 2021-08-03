import 'package:googleapis_auth/auth_io.dart';

import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/timetable_item_update.dart';

abstract class ITimetableUpdateRepository {
  Future<void> addTimetableUpdate(
    AuthClient client,
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
  );
}
