import 'dart:async';

import 'package:flutter/material.dart';

import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class MyTimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final StreamSink<String> errorSink;
  final Stream<Map<String, dynamic>> userDataStream;

  MyTimetableScreen({
    required this.textLocalizer,
    required this.errorSink,
    required this.userDataStream,
  });

  @override
  _MyTimetableScreenState createState() => _MyTimetableScreenState();
}

class _MyTimetableScreenState extends State<MyTimetableScreen> {

  @override
  void initState() {
    widget.userDataStream.listen((userData) {
      if (userData['groupId'] == null ||
          userData['groupId'] == '') {
        widget.errorSink.add(widget.textLocalizer
            .localize('You have not yet selected a group'));
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/timetable',
          arguments: {
            'type': 'group',
            'groupId': userData['groupId'],
            'subgroupId': userData['subgroupId']
          },
        );
      }
    }).onError((_, __) => Navigator.pop(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator(),));
  }
}
