class TimetableData {
  final String id;
  final bool enabled;
  final DateTime expiredAt;
  final DateTime lastModified;
  final WeekDetermination weekDetermination;

  TimetableData({
    required this.id,
    required this.enabled,
    required this.expiredAt,
    required this.lastModified,
    required this.weekDetermination,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      id: json['id'],
      enabled: int.parse(json['enabled']) == 1,
      expiredAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json['expiredAt'])),
      lastModified: DateTime.fromMillisecondsSinceEpoch(int.parse(json['lastModified'])),
      weekDetermination: (int.parse(json['weekDetermination']) == 0
          ? WeekDetermination.Odd
          : WeekDetermination.Even),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'enabled': enabled ? '1' : '0',
    'expiredAt': expiredAt.millisecondsSinceEpoch.toString(),
    'lastModified': lastModified.millisecondsSinceEpoch.toString(),
    'weekDetermination': weekDetermination == WeekDetermination.Odd ? '0' : '1',
  };
}

enum WeekDetermination { Even, Odd }
