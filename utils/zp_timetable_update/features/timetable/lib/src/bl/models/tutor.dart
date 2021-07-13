class Tutor {
  final int id;
  final String name;
  final String imageUrl;

  Tutor({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => Tutor(
        id: int.parse(json['id']),
        name: json['name'],
        imageUrl: json['imageUrl'],
      );

  toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
  };
}
