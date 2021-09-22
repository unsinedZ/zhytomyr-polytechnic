class ActivityName {
  final String name;

  ActivityName({
    required this.name,
  });

  factory ActivityName.fromJson(Map<String, dynamic> json) => ActivityName(
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
  };
}
