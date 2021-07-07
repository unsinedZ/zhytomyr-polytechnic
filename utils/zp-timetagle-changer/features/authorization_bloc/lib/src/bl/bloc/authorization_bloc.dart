import 'dart:convert';
import 'dart:io';

import 'package:authorization_bloc/src/bl/model/google_creditals.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

class AuthorizationBloc {
  final client = http.Client();

  void login(File file) async {
    try {
      GoogleCreditals googleCreditals =
          GoogleCreditals.fromJson(jsonDecode(await file.readAsString()));

      final jwt = JWT(
        {},
        header: {"kid": googleCreditals.privateKeyId},
        issuer: googleCreditals.clientEmail,
        subject: googleCreditals.clientEmail,
        audience: "https://fcm.googleapis.com/",
      );

      final token = jwt.sign(RSAPrivateKey(googleCreditals.privateKey),
          algorithm: JWTAlgorithm.RS256,
          expiresIn: Duration(milliseconds: 3600));

      print('Signed token: $token\n');
    } catch (error) {
      print(error.toString());
    }
  }
}
