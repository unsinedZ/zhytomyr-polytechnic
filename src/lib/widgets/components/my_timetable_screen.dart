import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_sync/user_sync.dart';

import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class MyTimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final StreamSink<String> errorSink;
  final Stream<User?> userStream;

  MyTimetableScreen({
    required this.textLocalizer,
    required this.errorSink,
    required this.userStream,
  });

  @override
  _MyTimetableScreenState createState() => _MyTimetableScreenState();
}

class _MyTimetableScreenState extends State<MyTimetableScreen> {
  @override
  void initState() {
    widget.userStream.listen((user) {
      if (user!.groupId == '') {
        widget.errorSink.add(
            widget.textLocalizer.localize('You have not yet selected a group'));
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/timetable',
          arguments: {
            'type': 'group',
            'groupId': int.parse(user.groupId),
            'subgroupId': user.subgroupId.isNotEmpty ? int.parse(user.subgroupId) : null
          },
        );
      }
    }).onError((_, __) => Navigator.pop(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
