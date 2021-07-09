import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:zp_timetable_update/bl/models/error_model.dart';

extension HttpResponseExtensions on Response {
  ensureSuccessStatusCode() {
    if (this.statusCode == HttpStatus.badRequest) {
      throw ErrorModel.fromJson(jsonDecode(this.body));
    }

    if (this.statusCode == 401) {
      throw ErrorModel(message: "Unauthorized");
    }

    if (this.statusCode > 400) {
      throw ErrorModel(message: "No connection");
    }
  }
}
