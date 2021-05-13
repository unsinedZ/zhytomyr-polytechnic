import 'dart:async';
import 'dart:io';

import 'package:apple_authentication/apple_authentication.dart';
import 'package:deep_links/deep_links.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:google_authentication/google_authentication.dart';
import 'package:user_sync/user_sync.dart';
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
    _userSubscription = Rx.combineLatest2(
            context.read<UserSyncBloc>().mappedUser,
            context.read<DeepLinkBloc>().dynamicLink,
            (a, b) => [a, b])
        .where((combinedValues) =>
            combinedValues[0] != null && !(combinedValues[0]! as User).isEmpty)
        .listen((combinedValues) {
      if (combinedValues[1] != null) {
        final Uri dynamicLink = (combinedValues[1]! as Uri);

        Navigator.pushReplacementNamed(
          context,
          dynamicLink.path,
          arguments: dynamicLink.queryParameters,
        );
        return;
      }
      Navigator.of(context).pushReplacementNamed('/faculties');
    });

    print(Platform.operatingSystem);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: StreamBuilder<User?>(
              stream: context.read<UserSyncBloc>().mappedUser,
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.isEmpty) {
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
                                context.read<GoogleAuthenticationBloc>(),
                          ),
                          AppleSignInButton(),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      );

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
