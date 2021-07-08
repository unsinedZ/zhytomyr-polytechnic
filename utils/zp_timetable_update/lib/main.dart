import 'package:flutter/material.dart';
import 'package:zp_timetable_update/widgets/app.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DesktopWindow.setWindowSize(Size(800, 700));

  runApp(App());
}
