import 'package:googleapis/firestore/v1.dart';

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
    'id': id.toString(),
    'name': name,
    'imageUrl': imageUrl,
  };

  MapValue toMapValue() {
    MapValue tutorMapValue = MapValue();

    tutorMapValue.fields = {
      'id': Value()..integerValue = id.toString(),
      'name': Value()..stringValue = name,
      'imageUrl': Value()..stringValue = imageUrl,
    };

    return tutorMapValue;
  }
}
