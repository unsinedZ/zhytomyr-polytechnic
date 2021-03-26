import 'package:flutter/material.dart';
import 'package:terms_and_conditions/terms_and_conditions.dart';

import 'app_context.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppContext.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TermsAndConditionsScreen(),
    );
  }
}
