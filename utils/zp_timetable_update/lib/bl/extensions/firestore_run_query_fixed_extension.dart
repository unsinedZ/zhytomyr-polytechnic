import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:googleapis/firestore/v1.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

extension FirestoreRunQueryFixedExtension
    on ProjectsDatabasesDocumentsResource {
  /// Runs a query.
  ///
  /// [request] - The metadata request object.
  ///
  /// Request parameters:
  ///
  /// [parent] - The parent resource name. In the format:
  /// `projects/{project_id}/databases/{database_id}/documents` or
  /// `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  /// For example:
  /// `projects/my-project/databases/my-database/documents` or
  /// `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  /// Value must have pattern
  /// "^projects/[^/]+/databases/[^/]+/documents/[^/]+/.+$".
  ///
  /// [$fields] - Selector specifying which fields to include in a partial
  /// response.
  ///
  /// Completes with a [RunQueryResponse].
  ///
  /// Completes with a [commons.ApiRequestError] if the API endpoint returned an
  /// error.
  ///
  /// If the used [http.Client] completes with an error when making a REST call,
  /// this method will complete with the same error.
  Future<List<Document>> runQueryFixed(RunQueryRequest request,
      {required http.Client client, String? parent}) async {
    // final projectId = 'zhytomyr-politechnic-dev';
    final urlParentAddition = parent != null ? '/$parent' : '';
    // final url =
    //     'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents$urlParentAddition:runQuery';
    final url =
        'http://127.0.0.1:8080/v1/projects/emulator/databases/(default)/documents$urlParentAddition:runQuery'; // TODO delete
    final body = json.encode(request.toJson());
    final response1 = await HttpClient().postUrl(
      Uri.parse(url),
    );
    response1.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    response1.write(body);
    final response = await response1.close();
    final resBody = await response.transform(utf8.decoder).first;

      final List<dynamic> decoded = json.decode(resBody) as List;
      if (decoded[0]['error'] != null) {
        throw Exception('Firestore Error: $resBody!');
      }
      final docs = [
        for (final docJson in decoded)
          if (docJson['document'] != null)
            Document.fromJson(docJson['document'] as Map)
      ];
      return docs;

    // final response = await client.post(
    //   Uri.parse(url),
    //   body: body,
    //   encoding: Encoding.getByName('utf-8'),
    //   headers: {
    //     "Accept": "application/json",
    //     "Content-Type": "application/json"
    //   },
    // );
    // final resBody = response.body;
    // final List<dynamic> decoded = json.decode(resBody) as List;
    // if (decoded[0]['error'] != null) {
    //   throw Exception('Firestore Error: $resBody!');
    // }
    // final docs = [
    //   for (final docJson in decoded)
    //     if (docJson['document'] != null)
    //       Document.fromJson(docJson['document'] as Map)
    // ];
    // return docs;
  }
}
