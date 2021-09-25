import 'dart:async';

import 'package:flutter/material.dart';

import 'package:navigation_drawer/src/bl/abstractions/text_localizer.dart';

class NavigationDrawer extends StatelessWidget {
  final TextLocalizer textLocalizer;
  final VoidCallback onSignOut;
  final StreamSink<String> errorSink;
  final CurrentPage currentPage;

  NavigationDrawer({
    required this.textLocalizer,
    required this.onSignOut,
    required this.errorSink,
    required this.currentPage,
  });

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
            title: Text(textLocalizer.localize('My timetable')),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/my-timetable',
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.wysiwyg),
            title: Text(textLocalizer.localize('Faculties')),
            onTap: () {
              if(currentPage == CurrentPage.Faculties){
                Navigator.of(context).pop();
                return;
              }
              Navigator.pushNamed(context, '/faculties');
            },
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text(textLocalizer.localize('Contacts')),
            onTap: () => Navigator.pushNamed(context, '/contacts'),
          ),
          ListTile(
            leading: Icon(Icons.text_snippet_outlined),
            title: Text(textLocalizer.localize('Terms and conditions')),
            onTap: () => Navigator.pushNamed(context, '/terms&conditions'),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(textLocalizer.localize('Sign out')),
            onTap: () => onSignOut(),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}

enum CurrentPage{
  Faculties
}
