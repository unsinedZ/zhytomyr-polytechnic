import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zp_timetable_update/widgets/app.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setMaxWindowSize(Size(800, 700));
    DesktopWindow.setMinWindowSize(Size(800, 700));
  }

  runApp(App());
}
