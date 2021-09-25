import 'package:timetable/src/bl/models/models.dart';

class TimetableItemUpdate {
  final String id;
  final String date;
  final String time;
  final TimetableItem? timetableItem;

  TimetableItemUpdate({
    required this.id,
    required this.date,
    required this.time,
    required this.timetableItem,
  });

  factory TimetableItemUpdate.fromJson(Map<String, dynamic> json) =>
      TimetableItemUpdate(
        id: json['id'],
        date: json['date'],
        time: json['time'],
        timetableItem: json['item'] != null ? TimetableItem.fromJson(json['item']) : null,
      );
}
