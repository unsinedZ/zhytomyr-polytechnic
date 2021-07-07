import 'dart:convert';
import 'dart:io';

//import 'package:googleapis/binaryauthorization/v1.dart';
// import 'package:authorization_bloc/src/bl/model/google_creditals.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;

class AuthorizationBloc {
  final client = http.Client();

  void login(File file) async {
    try {
      final clientCredentials = ServiceAccountCredentials.fromJson(
          jsonDecode(await file.readAsString()));
      final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        clientCredentials,
        ["https://www.googleapis.com/auth/cloud-platform"],
        client,
      );
      // GoogleCreditals googleCreditals =
      //     GoogleCreditals.fromJson(jsonDecode(await file.readAsString()));

      // final jwt = JWT(
      //   {},
      //   header: {"kid": googleCreditals.privateKeyId},
      //   issuer: googleCreditals.clientEmail,
      //   subject: googleCreditals.clientEmail,
      //   audience: "https://fcm.googleapis.com/",
      // );

      // final token = jwt.sign(RSAPrivateKey(googleCreditals.privateKey),
      //     algorithm: JWTAlgorithm.RS256,
      //     expiresIn: Duration(milliseconds: 3600));
      
      print('Signed token: $accessCredentials.accessToken\n');
    } catch (error) {
      print(error.toString());
    }
  }
}
