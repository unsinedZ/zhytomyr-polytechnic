import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:timetable/timetable.dart';
import 'package:provider/provider.dart';

import 'package:error_bloc/error_bloc.dart';

import 'package:zp_timetable_update/bl/repositories/main_firestore_repository.dart';
import 'package:zp_timetable_update/bl/repositories/timetable_firestore_repository_factory.dart';
import 'package:zp_timetable_update/bl/services/text_localizer.dart';
import 'package:zp_timetable_update/widgets/dependencies.dart';
import 'package:zp_timetable_update/widgets/screens/authorization_screen.dart';
import 'package:zp_timetable_update/widgets/screens/main_screen.dart';
import 'package:zp_timetable_update/widgets/with_startup_actions.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: WithStartupAction(
        child: MaterialApp(
          theme: ThemeData(
            canvasColor: Colors.white,
            primaryColor: Color(0xff35b9ca),
            focusColor: Color(0xfff8eb4d),
            disabledColor: Color(0xffeeeeee),
            hoverColor: Color(0xfff8f3b3),
            selectedRowColor: Color(0xffd6ffde),
            primaryIconTheme: IconThemeData(
              color: Colors.white,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xff35b9ca),
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Color(0xffeeeeee);
                      }
                      return Color(0xfff4e83d);
                    }),
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.black;
                  },
                ),
              ),
            ),
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              headline2: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              headline3: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              headline4: TextStyle(
                fontSize: 14,
                color: Color(0xff41c3fe),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Житомирська Політехніка',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          initialRoute: '/authentication',
          routes: {
            '/authentication': (context) => AuthorizationScreen(),
            '/main_screen': (context) => TimetableScreen(
                  textLocalizer: TextLocalizer(),
                  timetableRepositoryFactory:
                      TimetableFirestoreRepositoryFactory(),
                  tutorRepository: MainFirestoreRepository(),
                  errorSink: context.read<ErrorBloc>().errorSink,
                  //clientStream: context.read<AuthorizationBloc>().authClient,
                )
          },
        ),
      ),
    );
  }
}
