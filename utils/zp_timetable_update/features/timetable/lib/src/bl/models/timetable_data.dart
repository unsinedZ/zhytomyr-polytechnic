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
      enabled: (json['enabled'] as int) == 1,
      expiredAt: DateTime.fromMillisecondsSinceEpoch(json['expiredAt'] as int),
      lastModified: DateTime.fromMillisecondsSinceEpoch(json['lastModified'] as int),
      weekDetermination: (json['weekDetermination'] as int == 0
          ? WeekDetermination.Odd
          : WeekDetermination.Even),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'enabled': enabled ? 1 : 0,
    'expiredAt': expiredAt.millisecondsSinceEpoch,
    'lastModified': lastModified.millisecondsSinceEpoch,
    'weekDetermination': weekDetermination == WeekDetermination.Odd ? 0 : 1,
  };
}

enum WeekDetermination { Even, Odd }
