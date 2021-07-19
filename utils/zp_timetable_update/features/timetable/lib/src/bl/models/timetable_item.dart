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
      weekNumber: int.parse(json['weekNumber']),
      activity: Activity.fromJson(json['activity']),
      dayNumber: int.parse(json['dayNumber']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'weekNumber': weekNumber.toString(),
    'activity': activity.toJson(),
    'dayNumber': dayNumber.toString(),
  };
}
