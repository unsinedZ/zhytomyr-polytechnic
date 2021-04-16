class Subgroup {
  final String id;
  final String name;

  Subgroup({
    required this.id,
    required this.name,
  });

  factory Subgroup.fromJson(Map<String, dynamic> json) {
    return Subgroup(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  factory Subgroup.fromObject(dynamic object) {
    return Subgroup(
      id: object.id as String,
      name: object.name as String,
    );
  }

  toJson() => <String, dynamic>{
    'id': id,
    'name': name,
  };
}
