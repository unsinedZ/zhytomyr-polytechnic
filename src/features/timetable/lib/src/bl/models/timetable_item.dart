import 'models.dart';

class TimetableItem {
  final int weekNumber;
  final Activity activity;
  final int dayNumber;

  TimetableItem({
    required this.weekNumber,
    required this.activity,
    required this.dayNumber,
  });

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      weekNumber: json['weekNumber'] as int,
      activity: Activity.fromJson(json['activity']),
      dayNumber: json['dayNumber'] as int,
    );
  }
}
