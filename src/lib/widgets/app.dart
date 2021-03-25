import 'package:flutter/material.dart';

import 'package:zhytomyr_polytechnic/widgets/screens/authentication_screen.dart';

import 'dependecies.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: MaterialApp(
        initialRoute: 'authentication',
        routes: <String, WidgetBuilder>{
          'authentication': (context) => AuthenticationScreen(),
        },
      ),
    );
  }
}
