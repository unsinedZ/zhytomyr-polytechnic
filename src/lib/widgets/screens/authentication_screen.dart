import 'package:flutter/material.dart';

import 'package:google_authentication/google_authentication.dart';

import 'package:zhytomyr_polytechnic/widgets/screens/user_info_screen.dart';

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
                    FlutterLogo(
                      size: 250,
                    ),
                    SizedBox(
                      height: 110,
                    ),
                    GoogleSignInButton(
                      authorizationCallback: (user) =>
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => UserInfoScreen(
                                user: user,
                              ),
                            ),
                          ),
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
