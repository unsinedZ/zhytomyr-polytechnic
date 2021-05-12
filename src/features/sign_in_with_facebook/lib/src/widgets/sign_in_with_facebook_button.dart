import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sign_in_with_facebook/src/bl/facebook_authentication_bloc.dart';

class SignInWithFacebookButton extends StatefulWidget {
  final FacebookAuthenticationBloc authenticationBloc;

  SignInWithFacebookButton({
    required this.authenticationBloc,
  });

  @override
  _SignInWithFacebookButtonState createState() => _SignInWithFacebookButtonState();
}

class _SignInWithFacebookButtonState extends State<SignInWithFacebookButton> {
  @override
  void initState() {
    widget.authenticationBloc.loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {
          widget.authenticationBloc.login();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.facebook,
                size: 33,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Facebook',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
