import 'package:googleapis/firestore/v1.dart';
import 'package:update_form/src/bl/models/timetable_item.dart';

class TimetableItemUpdate {
  final String id;
  final String date;
  final String time;
  final TimetableItem? timetableItem;

  TimetableItemUpdate({
    required this.id,
    required this.date,
    required this.time,
    required this.timetableItem,
  });

  factory TimetableItemUpdate.fromJson(Map<String, dynamic> json) =>
      TimetableItemUpdate(
        id: json['id'],
        date: json['date'],
        time: json['time'],
        timetableItem:
            json['item'] != null ? TimetableItem.fromJson(json['item']) : null,
      );

  List<Document> toDocuments() {
    List<Document> documents = <Document>[];

    timetableItem!.activity.groups.forEach((group) {
      documents.add(createDocument('groupKey', 'group/' + group.id.toString()));
    });

    timetableItem!.activity.tutors.forEach((tutor) {
      documents.add(createDocument('tutorKey', 'tutor/' + tutor.id.toString()));
    });

    return documents;
  }

  Document createDocument(String key, String keyValue) {
    Document timetableDocument = Document();

    MapValue timetableItemMapValue = MapValue();

    timetableItemMapValue.fields = {
      'dayNumber': Value()..integerValue = timetableItem!.dayNumber.toString(),
      'weekNumber': Value()
        ..integerValue = timetableItem!.weekNumber.toString(),
      'activity': Value()..mapValue = timetableItem!.activity.toMapValue(),
    };

    Map<String, Value> fields = {
      'date': Value()..stringValue = date,
      key: Value()..stringValue = keyValue,
      'time': Value()..stringValue = time,
      'item': Value()..mapValue = timetableItemMapValue,
      'id': Value()..stringValue = id,
    };

    timetableDocument.fields = fields;

    return timetableDocument;
  }
}
