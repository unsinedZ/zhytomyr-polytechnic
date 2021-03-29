import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:zhytomyr_polytechnic/widgets/screens/authentication_screen.dart';

import 'dependecies.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        initialRoute: 'authentication',
        routes: <String, WidgetBuilder>{
          'authentication': (context) => AuthenticationScreen(),
        },
      ),
    );
  }
}
