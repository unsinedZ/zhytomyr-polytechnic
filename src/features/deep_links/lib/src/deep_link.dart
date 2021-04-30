import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';

import 'package:deep_links/deep_links.dart';
import 'package:flutter/material.dart';

class DeepLink extends StatefulWidget {
  final Widget child;
  final List<Link> links;
  final Function(Object error, StackTrace stack) fallbackCallback;

  const DeepLink({
    this.links = const [],
    required this.child,
    required this.fallbackCallback,
  }) : super();

  @override
  _DeepLinkState createState() => _DeepLinkState();
}

class _DeepLinkState extends State<DeepLink> {
  @override
  void initState() {
    FirebaseDynamicLinks.instance.getInitialLink().then(
        (PendingDynamicLinkData? dynamicLink) async {
      if (dynamicLink == null) {
        return;
      }

      if (widget.links.isEmpty) {
        throw Exception("Links list is empty");
      }

      widget.links.forEach((link) {
        if (dynamicLink.link.path == link.link) {
          if (link.isNamed) {
            Navigator.pushNamed(context, link.link,
                arguments: dynamicLink.link.queryParameters);
          }

          if (link.route == null) {
            throw NullThrownError();
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => link.route!,
                  settings: RouteSettings(
                      arguments: dynamicLink.link.queryParameters)));
        }
      });
    }, onError: (Object error, StackTrace stack) => widget.fallbackCallback);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
