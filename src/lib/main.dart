import 'package:flutter/material.dart';
import 'package:group_selection_screen/group_selection_screen.dart';

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
      home: GroupSelectionScreen(),
    );
  }
}
