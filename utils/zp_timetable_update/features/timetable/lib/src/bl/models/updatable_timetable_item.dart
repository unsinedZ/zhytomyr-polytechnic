import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/string_extension.dart';

class UpdatableTimetableItem {
  final TimetableItem? timetableItem;
  final TimetableItemUpdate? timetableItemUpdate;

  UpdatableTimetableItem({
    required this.timetableItem,
    required this.timetableItemUpdate,
  });

  bool get isNew =>
      timetableItem == null &&
      timetableItemUpdate != null &&
      timetableItemUpdate!.timetableItem != null;

  bool get isEmpty =>
      timetableItem == null &&
      (timetableItemUpdate == null ||
          timetableItemUpdate!.timetableItem == null);

  bool get isUpdated => timetableItem != null && timetableItemUpdate != null;

  bool get isCancelled =>
      isUpdated && timetableItemUpdate!.timetableItem == null;

  bool get isReplaced =>
      isUpdated && timetableItemUpdate!.timetableItem != null;

  bool get isSimple =>
      timetableItem != null && timetableItemUpdate == null;

  int compareTo(UpdatableTimetableItem updatableTimetableItem) {
    Activity aActivity = this.timetableItem != null
        ? this.timetableItem!.activity
        : this.timetableItemUpdate!.timetableItem!.activity;
    Activity bActivity = updatableTimetableItem.timetableItem != null
        ? updatableTimetableItem.timetableItem!.activity
        : updatableTimetableItem.timetableItemUpdate!.timetableItem!.activity;

    return aActivity.time.start.compareAsTimeTo(bActivity.time.start);
  }
}
