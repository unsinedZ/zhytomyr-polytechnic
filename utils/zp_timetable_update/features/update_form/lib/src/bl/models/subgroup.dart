class Subgroup {
  final int id;
  final String name;

  Subgroup({
    required this.id,
    required this.name,
  });

  factory Subgroup.fromJson(Map<String, dynamic> json) {
    return Subgroup(
      id: int.parse(json['id']),
      name: json['name'] as String,
    );
  }

  factory Subgroup.fromObject(dynamic object) {
    return Subgroup(
      id: object.id as int,
      name: object.name as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id.toString(),
    'name': name,
  };
}
