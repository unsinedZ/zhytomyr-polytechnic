import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zhytomyr_polytechnic/app.dart';

Future<void> main() async {
  await initLocalizationAsync();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('uk'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: App()),
  );
}

Future<void> initLocalizationAsync() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}
