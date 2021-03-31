import 'package:flutter/material.dart';

import 'package:google_authentication/google_authentication.dart';

import 'package:provider/provider.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    SizedBox(
                      height: 110,
                    ),
                    GoogleSignInButton(
                      authorizationCallback: (_) =>
                          Navigator.of(context).pushNamed('/faculties'),
                      userBloc: context.read<AuthenticationBloc>(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
