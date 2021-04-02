class Timeslot {
  final String start;
  final String end;

  Timeslot({required this.start, required this.end});

  factory Timeslot.fromJson(Map<String, dynamic> json) =>
      Timeslot(start: json['start'], end: json['end']);
}
