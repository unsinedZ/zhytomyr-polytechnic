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

  final BehaviorSubject<GoogleUser?> _userSubject = BehaviorSubject();

  Stream<GoogleUser?> get user => _userSubject.stream;

  void loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.providerData.last.providerId == providerId) {
        _userSubject.add(GoogleUser.fromLogin(user));
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

      _userSubject.add(null);

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

      _userSubject.add(GoogleUser.fromLogin(user!));
    } catch (err) {
      errorSink.add(err.toString());
      _userSubject.add(GoogleUser.empty());
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    _userSubject.add(GoogleUser.empty());
  }

  void dispose() {
    _userSubject.close();
  }
}
