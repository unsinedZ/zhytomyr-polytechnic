import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timetable_screen/src/abstractions/text_localizer.dart';

class TimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;

  TimetableScreen(
      {required this.textLocalizer})
      : super();

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.textLocalizer.localize('Timetable')),
      ),
      body: Container(
        
      )
    );
  }
}
