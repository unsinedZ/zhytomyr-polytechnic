import 'package:timetable/src/bl/models/models.dart';

class Timetable {
  final List<TimetableItem>? items;
  final String? expiresAt;
  final WeekDetermination weekDetermination;

  Timetable({
    this.items,
    this.expiresAt,
    required this.weekDetermination,
  });

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
