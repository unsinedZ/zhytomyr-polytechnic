import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:push_notification/push_notification.dart';
import 'package:zhytomyr_polytechnic/widgets/app.dart';

Future<void> main() async {
  await initLocalizationAsync();
  runZonedGuarded(() {
    runApp(
      Phoenix(
        child: EasyLocalization(
            supportedLocales: [Locale('uk'), Locale('en')],
            path: "assets/translations",
            fallbackLocale: Locale('uk'),
            child: App()),
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

Future<void> initLocalizationAsync() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
  initNotification();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
