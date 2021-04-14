import 'package:timetable/src/bl/models/models.dart';

class UpdatableTimetableItem {
  final TimetableItem? timetableItem;
  final TimetableItemUpdate? timetableItemUpdate;

  UpdatableTimetableItem({
    required this.timetableItem,
    required this.timetableItemUpdate,
  });
}
