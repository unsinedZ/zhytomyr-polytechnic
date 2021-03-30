import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zhytomyr_polytechnic/app_constants.dart';
import 'package:zhytomyr_polytechnic/widgets/app.dart';

Future<void> main() async {
  await initLocalizationAsync();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('uk'), Locale('en')],
        path: AppConstants.translationPath,
        fallbackLocale: Locale('en'),
        child: App()),
  );
}

Future<void> initLocalizationAsync() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
