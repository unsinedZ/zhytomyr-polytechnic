import 'package:flutter/material.dart';
import 'package:zhytomyr_polytechnic/app_context.dart';
import 'package:easy_localization/easy_localization.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => Center(
                child: Text(
                  AppContext.appName.tr(),
                ),
              )
        },
      );
}
