import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_authentication/google_authentication.dart';
import 'package:rxdart/rxdart.dart';

import 'package:provider/provider.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextLocalizer textLocalizer = TextLocalizer();
  late StreamSubscription _userSubscription;

  @override
  void initState() {
    _userSubscription = context.read<AuthenticationBloc>().user.listen((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/faculties');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: StreamBuilder<List<dynamic>>(
            stream: Rx.combineLatest2(
                context.read<AuthenticationBloc>().isLoginNow,
                context.read<AuthenticationBloc>().user,
                (a, b) => [a, b]),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.data![0] == true || snapshot.data![1] != null)) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
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
                            Text(textLocalizer
                                .localize('By authorize you agree to ')),
                            InkWell(
                              child: Text(
                                textLocalizer.localize('terms & conditions.'),
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              onTap: () => Navigator.pushNamed(
                                  context, '/terms&conditions'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GoogleSignInButton(
                          authenticationBloc:
                              context.read<AuthenticationBloc>(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
