import 'package:flutter/cupertino.dart';

class Link {
  final String link;
  final Widget? route;
  final bool isNamed;

  Link({
    required this.link,
    this.route,
    this.isNamed = true,
  });
}
