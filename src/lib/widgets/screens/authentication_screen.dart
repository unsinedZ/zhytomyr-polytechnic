import 'package:flutter/material.dart';

import 'package:google_authentication/google_authentication.dart';

import 'package:group_selection/group_selection.dart' hide TextLocalizer;

import 'package:provider/provider.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

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
                          Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => GroupSelectionScreen(
                            textLocalizer: TextLocalizer(),
                            firebaseDataGetter: FirebaseDataGetterMock(),
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
