import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:googleapis/firestore/v1.dart';

import 'package:zp_timetable_update/bl/extensions/firestore_run_query_fixed_extension.dart';

class TimetableUpdateApi {
  static Future<List<Document>> runQuery({
    required AuthClient client,
    required String collectionId,
    required String fieldPath,
    required String fieldValue,
    required ValueType valueType,
  }) async {
    FirestoreApi firestoreApi = FirestoreApi(client);
    RunQueryRequest runQueryRequest = RunQueryRequest();
    StructuredQuery structuredQuery = StructuredQuery();
    Filter filter = Filter();
    FieldFilter fieldFilter = FieldFilter();
    FieldReference fieldReference = FieldReference();
    fieldReference.fieldPath = fieldPath;
    Value value = Value();
    if (valueType == ValueType.String) {
      value.stringValue = fieldValue;
    } else if (valueType == ValueType.Int) {
      value.integerValue = fieldValue;
    }

    fieldFilter.value = value;
    fieldFilter.field = fieldReference;
    fieldFilter.op = 'EQUAL';

    filter.fieldFilter = fieldFilter;

    structuredQuery.where = filter;

    CollectionSelector collectionSelector = CollectionSelector();
    collectionSelector.collectionId = collectionId;
    collectionSelector.allDescendants = true;

    structuredQuery.from = [collectionSelector];

    runQueryRequest.structuredQuery = structuredQuery;

    List<Document> documents =
    await firestoreApi.projects.databases.documents.runQueryFixed(
      runQueryRequest,
      client: client,
    );

    return documents;
  }
}

enum ValueType { Int, String }