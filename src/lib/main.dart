import 'dart:async';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

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
  String host = defaultTargetPlatform == TargetPlatform.android
      ? '192.168.0.104:9190'
      : 'localhost:9190'; // TODO delete

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings =
      Settings(host: host, sslEnabled: false); // TODO delete

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }

  initNotification();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
