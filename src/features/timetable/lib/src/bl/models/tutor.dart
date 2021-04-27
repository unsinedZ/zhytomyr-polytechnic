class Tutor {
  final String id;
  final String name;
  final String imageUrl;

  Tutor({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => Tutor(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
      );

  toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
  };
}
