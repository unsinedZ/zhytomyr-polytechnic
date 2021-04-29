import 'dart:async';

import 'package:flutter/material.dart';

import 'package:navigation_drawer/src/bl/abstractions/text_localizer.dart';
import 'package:navigation_drawer/src/bl/models/user.dart';

class NavigationDrawer extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final VoidCallback onSignOut;
  final Stream<Map<String, dynamic>> userJsonStream;
  final StreamSink<String> errorSink;

  NavigationDrawer({
    required this.textLocalizer,
    required this.onSignOut,
    required this.userJsonStream,
    required this.errorSink,
  });

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  User? user;

  @override
  void initState() {
    widget.userJsonStream.listen((userJson) {
      setState(() {
        user = User.fromStorage(userJson);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Image.asset(
              'assets/drawer_header.png',
              package: 'navigation_drawer',
              alignment: Alignment.topCenter,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text(widget.textLocalizer.localize('My timetable')),
            onTap: user == null
                ? null
                : () {
                    if (user!.data['groupId'] == null ||
                        user!.data['groupId'] == '') {
                      widget.errorSink.add(widget.textLocalizer
                          .localize('You have not yet selected a group'));
                    } else {
                      Navigator.pushNamed(
                        context,
                        '/timetable',
                        arguments: [
                          'group',
                          user!.data['groupId'],
                          user!.data['subgroupId'],
                        ],
                      );
                    }
                  },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.wysiwyg),
            title: Text(widget.textLocalizer.localize('Faculties')),
            onTap: () => Navigator.pushNamed(context, '/faculties'),
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text(widget.textLocalizer.localize('Contacts')),
            onTap: () => Navigator.pushNamed(context, '/contacts'),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(widget.textLocalizer.localize('Sign out')),
            onTap: () => widget.onSignOut(),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
