import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:toast/src/bl/toast_view.dart';

class Toast {
  static final int lengthShort = 1;
  static final int lengthLong = 2;
  static final int bottom = 0;
  static final int center = 1;
  static final int top = 2;

  static void show(String msg, BuildContext context,
      {int? duration = 1,
      int? gravity = 0,
      Color backgroundColor = const Color(0xAA000000),
      textStyle = const TextStyle(fontSize: 15, color: Colors.white),
      double backgroundRadius = 20,
      bool? rootNavigator,
      Border? border}) {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor,
        textStyle, backgroundRadius, border, rootNavigator);
  }
}