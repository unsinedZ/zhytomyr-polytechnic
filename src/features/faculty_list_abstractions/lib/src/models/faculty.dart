class Faculty {
  final String id;
  final String name;
  final String imageUrl;

  Faculty({required this.id, required this.name, required this.imageUrl});

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
      id: json["id"] as String,
      name: json["name"] as String,
      imageUrl: json["imageUrl"] as String);
}
