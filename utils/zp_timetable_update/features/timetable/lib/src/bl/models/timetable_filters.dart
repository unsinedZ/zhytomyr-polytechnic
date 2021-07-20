import 'package:timetable/src/widgets/timetable_screen.dart';

class TimetableFilters {
  final int weekNumber;
  final int weekDayNumber;
  final TimetableType timetableType;
  final int id;
  final int? subgroupId;

  TimetableFilters({
    required this.weekNumber,
    required this.weekDayNumber,
    required this.timetableType,
    required this.id,
    required this.subgroupId,
  });

  factory TimetableFilters.fromJson(Map<String, dynamic> json) {
    return TimetableFilters(
      weekNumber: json['weekNumber'] as int,
      weekDayNumber: json['weekDayNumber'] as int,
      timetableType: timetableTypeFromString(json['timetableType'] as String),
      id: json['id'] as int,
      subgroupId: json['weekDayNumber'] as int?,
    );
  }
}
