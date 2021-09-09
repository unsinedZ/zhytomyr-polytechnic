import 'package:update_form/src/bl/models/activity_name.dart';
import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/timetable_item_update.dart';

abstract class ITimetableUpdateRepository {
  Future<void> addTimetableUpdate(
    TimetableItemUpdate timetableItemUpdate,
    List<Group> groups,
    List<Group>? initialGroups,
  );

  Future<List<ActivityName>> loadSubjectNames();
}
