import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_authentication/src/models/google_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

class GoogleAuthenticationBloc {
  final StreamSink<String> errorSink;

  GoogleAuthenticationBloc({
    required this.errorSink,
  });

  var _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<GoogleUser?> _userController = BehaviorSubject();

  Stream<GoogleUser?> get user => _userController.stream;

  void loadUser() async {
    try {
      if (await GoogleSignIn().isSignedIn()) {
        _userController
            .add(GoogleUser.fromLogin(FirebaseAuth.instance.currentUser!));
      } else {
        _userController.add(null);
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
      _userController.add(null);
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
