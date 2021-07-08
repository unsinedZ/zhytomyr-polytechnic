import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';

import 'package:zp_timetable_update/widgets/dependencies.dart';
import 'package:zp_timetable_update/widgets/screens/authorization_screen.dart';
import 'package:zp_timetable_update/widgets/screens/main_screen.dart';
import 'package:zp_timetable_update/widgets/with_startup_actions.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: WithStartupAction(
        child: MaterialApp(
          title: 'Житомирська Політехніка',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            primaryColor: Color(0xff35b9ca),
          ),
          initialRoute: '/authentication',
          routes: {
            '/authentication': (context) => AuthorizationScreen(),
            '/main_screen': (context) => MainScreen()
          },
        ),
      ),
    );
  }
}
