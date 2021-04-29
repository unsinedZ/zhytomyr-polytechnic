import 'dart:async';

import 'package:flutter/material.dart';

import 'package:timetable/timetable.dart' hide TextLocalizer;
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class MyTimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final TimetableRepositoryFactory timetableRepositoryFactory;
  final GroupRepository groupRepository;
  final StreamSink<String> errorSink;
  final Stream<Map<String, dynamic>> userDataStream;

  MyTimetableScreen({
    required this.textLocalizer,
    required this.timetableRepositoryFactory,
    required this.groupRepository,
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
      UserData user = UserData.fromJson(userData);
      if (user.data['groupId'] == null ||
          user.data['groupId'] == '') {
        widget.errorSink.add(widget.textLocalizer
            .localize('You have not yet selected a group'));
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/timetable',
          arguments: [
            'group',
            user.data['groupId'],
            user.data['subgroupId'],
          ],
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
