import 'models.dart';

class TimetableItem {
  TimetableItem({
    this.weekNumber,
    this.activity,
  });

  int? weekNumber;
  Activity? activity;

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      weekNumber: json['weekNumber'] as int,
      activity: Activity.fromJson(json['activity']),
    );
  }
}
