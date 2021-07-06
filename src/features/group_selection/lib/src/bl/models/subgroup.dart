class Subgroup {
  final int id;
  final String name;

  Subgroup({
    required this.id,
    required this.name,
  });

  factory Subgroup.fromJson(Map<String, dynamic> json) {
    return Subgroup(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
