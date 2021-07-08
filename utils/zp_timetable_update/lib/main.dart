import 'package:flutter/material.dart';
import 'package:zp_timetable_update/widgets/app.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setWindowSize(Size(800, 500));

  runApp(App());
}
