import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationBloc {
  final StreamSink errorSink;
  final Client client;

  AuthorizationBloc({required this.errorSink, required this.client});

  final StreamController<String?> _authorizationController = StreamController();

  Stream<String?> get token => _authorizationController.stream;

  void login(File file) async {
    try {
      final serviceAccount = await file.readAsString();
      final storage = await SharedPreferences.getInstance();
      final clientCredentials =
          ServiceAccountCredentials.fromJson(jsonDecode(serviceAccount));
      final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        clientCredentials,
        [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/datastore"
        ],
        client,
      );
      storage.setString("account", serviceAccount);
      _authorizationController.add(accessCredentials.accessToken.data);
    } catch (error) {
      errorSink.add(error.toString());
      print(error.toString());
    }
  }
}
