import 'package:timetable/src/bl/models/models.dart';

class Timetable {
  Timetable({
    this.items,
    this.expiresAt,
    this.weekDetermination,
  });

  List<TimetableItem>? items;
  String? expiresAt;
  WeekDetermination? weekDetermination;

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      items: (json['timetableItems'] as List<dynamic>)
          .map((timetableItemJson) => TimetableItem.fromJson(timetableItemJson))
          .toList(),
      expiresAt: json['expiresAt'] as String,
      weekDetermination: (json['weekDetermination'] as int == 0
          ? WeekDetermination.Odd
          : WeekDetermination.Even),
    );
  }
}

enum WeekDetermination { Even, Odd }
