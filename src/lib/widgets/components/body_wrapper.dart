import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:update_check/update_check.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class BodyWrapper extends StatefulWidget {
  final Widget child;

  BodyWrapper({required this.child});

  @override
  _BodyWrapperState createState() => _BodyWrapperState();
}

class _BodyWrapperState extends State<BodyWrapper> {
  @override
  void initState() {
    context.read<UpdateCheckBloc>().version.listen((version) {
      if (version != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(TextLocalizer().localize('Press for update your app')),
          duration: Duration(days: 1),
          action: SnackBarAction(
            label: TextLocalizer().localize('Update'),
            onPressed: () async {
              if (await canLaunch(version.url)) {
                await launch(version.url);
              }
            },
          ),
        ));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
