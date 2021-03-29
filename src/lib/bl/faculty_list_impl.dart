import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty_list_abstractions/faculty_list_abstractions.dart';

class FirestoreFacultyRepository implements FacultyRepository {
  @override
  Stream<List<Faculty>> getList() =>
      FirebaseFirestore.instance.collection('faculty').get().asStream().map(
            (facultyListJson) => facultyListJson.docs.map(
              (facultyJson) => Faculty.fromJson(facultyJson.data()),
            ).toList(),
          );
}
