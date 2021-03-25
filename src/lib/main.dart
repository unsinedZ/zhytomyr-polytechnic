import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zhytomyr_polytechnic/widgets/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(App());
}

Future<void> init() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
