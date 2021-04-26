import 'package:flutter/material.dart';

import 'package:google_authentication/google_authentication.dart';

import 'package:provider/provider.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class AuthenticationScreen extends StatelessWidget {
  final TextLocalizer textLocalizer = TextLocalizer();

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
                      height: 90,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(textLocalizer.localize('By authorize you agree to ')),
                        InkWell(
                          child: Text(textLocalizer.localize('terms & conditions.'), style: Theme.of(context).textTheme.headline4,),
                          onTap: () => Navigator.pushNamed(context, '/terms&conditions'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GoogleSignInButton(
                      authorizationCallback: (_) => Navigator.of(context)
                          .pushReplacementNamed('/faculties'),
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
