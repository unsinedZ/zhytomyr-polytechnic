part of google_authentication;



class AuthenticationBloc {
  final StreamSink<String>? errorSink;

  AuthenticationBloc({
    this.errorSink,
  });

  final BehaviorSubject<User?> _userController = BehaviorSubject()..add(null);

  Stream<User?> get user => _userController.stream;

  void loadUser() async {
    _userController.add(null);

    if (await GoogleSignIn().isSignedIn()) {
      await Firebase.initializeApp();
      _userController.add(FirebaseAuth.instance.currentUser);
    } else {
      _userController.add(null);
    }
  }

  Future<void> login() async {
    _userController.add(null);

    try {
      await Firebase.initializeApp();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      print(user);

      _userController.add(user);
    } catch (_) {
      _userController.add(null);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    _userController.add(null);
  }

  void dispose() {
    _userController.close();
  }
}
