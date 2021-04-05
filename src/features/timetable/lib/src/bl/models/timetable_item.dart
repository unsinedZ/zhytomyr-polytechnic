import 'models.dart';

class TimetableItem {
  final int weekNumber;
  final Activity activity;

  TimetableItem({
    required this.weekNumber,
    required this.activity,
  });

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      weekNumber: json['weekNumber'] as int,
      activity: Activity.fromJson(json['activity']),
    );
  }
}
