import 'package:flutter/material.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatefulWidget {


  @override
  _AppleSignInButtonState createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends State<AppleSignInButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SignInWithAppleButton(
        onPressed: () async {
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          print(credential);

          // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
          // after en validated with Apple (see `Integration` section for more information on how to do this)
        },
      ),
    );
  }
}
