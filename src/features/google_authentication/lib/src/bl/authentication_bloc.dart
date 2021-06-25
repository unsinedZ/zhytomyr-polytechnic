import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:google_authentication/src/models/google_user.dart';

class GoogleAuthenticationBloc {
  static const String providerId = "google.com";

  final StreamSink<String> errorSink;

  GoogleAuthenticationBloc({
    required this.errorSink,
  });

  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<GoogleUser?> _userController = BehaviorSubject();

  Stream<GoogleUser?> get user => _userController.stream;

  void loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.providerData.last.providerId == providerId) {
        _userController.add(GoogleUser.fromLogin(user));
      }
    } catch (err) {
      errorSink.add(err.toString());
    }
  }

  Future<void> login() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      _userController.add(null);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      _logger.d('Signed in Google user');
      _logger.d(user);

      _userController.add(GoogleUser.fromLogin(user!));
    } catch (err) {
      errorSink.add(err.toString());
      _userController.add(GoogleUser.empty());
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    _userController.add(GoogleUser.empty());
  }

  void dispose() {
    _userController.close();
  }
}
