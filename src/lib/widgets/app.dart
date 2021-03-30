import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:zhytomyr_polytechnic/widgets/screens/authentication_screen.dart';

import 'dependecies.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: MaterialApp(
        theme: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Color(0xff35b9ca),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white;
                }
                return Color(0xfff4e83d);
              }),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.black;
              }),
            ),
          ),
        ),
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
