import 'package:timetable/src/bl/models/models.dart';

class TimetableItemUpdate {
  final String date;
  final String time;
  final TimetableItem timetableItem;

  TimetableItemUpdate({
    required this.date,
    required this.time,
    required this.timetableItem,
  });

  factory TimetableItemUpdate.fromJson(Map<String, dynamic> json) =>
      TimetableItemUpdate(
        date: json['date'],
        time: json['time'],
        timetableItem: TimetableItem.fromJson(json['timetableItem']),
      );
}
