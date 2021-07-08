import 'package:timetable/src/bl/models/models.dart';

class Timetable {
  final List<TimetableItem> items;
  final TimetableData timetableData;

  Timetable({
    required this.items,
    required this.timetableData,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      items: (json['items'] as List<dynamic>)
          .map((timetableItemJson) => TimetableItem.fromJson(timetableItemJson))
          .toList(),
      timetableData: TimetableData.fromJson(json['timetableData'])
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'items': items.map((item) => item.toJson()).toList(),
    'timetableData': timetableData.toJson(),
  };
}
