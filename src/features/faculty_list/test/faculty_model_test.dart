import 'package:faculty_list/src/models/faculty.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Faculty.fromJson work correctly", () {
    final Faculty faculty =
        Faculty.fromJson({"id": "1", "name": "name", "imageUrl": "imageUrl"});
    expect(faculty.id, "1");
    expect(faculty.name, "name");
    expect(faculty.imageUrl, "imageUrl");
  });
}
