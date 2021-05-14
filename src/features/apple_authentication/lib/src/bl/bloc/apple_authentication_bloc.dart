import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';

import 'package:apple_authentication/src/bl/models/apple_user.dart';

class AppleAuthenticationBloc {
  final StreamSink<String> errorSink;

  AppleAuthenticationBloc({
    required this.errorSink,
  });

  var _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<AppleUser?> _userController = BehaviorSubject();

  Stream<AppleUser?> get user => _userController.stream;

  void loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      _userController
          .add(AppleUser.fromLogin(FirebaseAuth.instance.currentUser!));
    } catch (_) {}
  }

  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void login() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      User? user =
          (await FirebaseAuth.instance.signInWithCredential(oauthCredential))
              .user;

      _logger.d('Signed in Apple user');
      _logger.d(user);

      _userController.add(AppleUser.fromLogin(user!));
    } catch (err) {
      print(err.runtimeType.toString());
      errorSink.add(err.toString());
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    _userController.add(AppleUser.empty());
  }

  void dispose() {
    _userController.close();
  }
}
