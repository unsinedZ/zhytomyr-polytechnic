class Subgroup {
  Subgroup({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Subgroup.fromJson(Map<String, dynamic> json) {
    return Subgroup(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
