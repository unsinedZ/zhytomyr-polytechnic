import 'package:flutter/material.dart';

import 'package:zp_timetable_update/widgets/dependencies.dart';

import 'package:zp_timetable_update/widgets/screens/authorization_screen.dart';
import 'package:zp_timetable_update/widgets/with_startup_actions.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: WithStartupAction(
        child: MaterialApp(
          title: 'Житомирська Політехніка',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AuthorizationScreen(),
        ),
      ),
    );
  }
}
