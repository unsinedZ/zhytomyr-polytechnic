import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key? key,
    required this.widget,
    required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final int? gravity;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: gravity == 2 ? MediaQuery.of(context).viewInsets.top + 50 : null,
        bottom: gravity == 0 ? MediaQuery.of(context).viewInsets.bottom + 50 : null,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ));
  }
}