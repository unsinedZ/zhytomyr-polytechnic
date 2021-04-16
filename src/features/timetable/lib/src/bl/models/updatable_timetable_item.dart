import 'package:timetable/src/bl/models/models.dart';

class UpdatableTimetableItem {
  final TimetableItem? timetableItem;
  final TimetableItemUpdate? timetableItemUpdate;

  UpdatableTimetableItem({
    required this.timetableItem,
    required this.timetableItemUpdate,
  });

  bool get isNew => timetableItem == null;

  bool get isUpdated => timetableItem != null && timetableItemUpdate != null;

  bool get isCancelled =>
      isUpdated && timetableItemUpdate!.timetableItem == null;

  bool get isReplaced => isUpdated && timetableItemUpdate!.timetableItem != null;
}
