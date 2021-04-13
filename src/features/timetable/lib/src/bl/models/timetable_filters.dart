import 'package:timetable/src/widgets/timetable_screen.dart';

class TimetableFilters {
  final int weekNumber;
  final int weekDayNumber;
  final TimetableType timetableType;
  final String id;
  final String? subgroupId;

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
      timetableType: json['timetableType'] == 'group'
          ? TimetableType.Group
          : TimetableType.Teacher,
      id: json['id'] as String,
      subgroupId: json['weekDayNumber'] as String?,
    );
  }
}
