import 'package:flutter/material.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:apple_authentication/src/bl/bloc/apple_authentication_bloc.dart';

class AppleSignInButton extends StatefulWidget {
  final AppleAuthenticationBloc appleAuthenticationBloc;

  AppleSignInButton({required this.appleAuthenticationBloc});

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
    return SignInWithAppleButton(
      onPressed: () {
        widget.appleAuthenticationBloc.login();
      },
    );
  }
}
