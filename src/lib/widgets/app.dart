import 'package:flutter/material.dart';

import 'package:zhytomyr_polytechnic/widgets/screens/authentication_screen.dart';

import 'dependecies.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green,
          buttonColor: Colors.green,
          errorColor: Colors.red,
          disabledColor: Color(0xFFD9D9D9),
          textTheme: TextTheme(
            headline1:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            headline2: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            headline3: TextStyle(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w300),
            headline4: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            headline5: TextStyle(color: Colors.grey),
            headline6: TextStyle(color: Colors.white70, fontSize: 20),
            bodyText1: TextStyle(color: Colors.green),
          ),
        ),
        initialRoute: 'authentication',
        routes: <String, WidgetBuilder>{
          'authentication': (context) => AuthenticationScreen(),
        },
      ),
    );
  }
}
