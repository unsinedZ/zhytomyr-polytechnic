import 'dart:async';

import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  final VoidCallback onSignOut;

  NavigationDrawer({
    required this.onSignOut,
  });

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Вихід'),
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
