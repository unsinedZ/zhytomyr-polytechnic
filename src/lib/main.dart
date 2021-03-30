import 'package:flutter/material.dart';
import 'package:group_selection/group_selection.dart';

import 'app_context.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppContext.appName,
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
      home: GroupSelectionScreen(),
    );
  }
}
