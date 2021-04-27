import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:google_authentication/google_authentication.dart';
import 'package:provider/provider.dart';

import 'package:timetable/timetable.dart' hide TextLocalizer;
import 'package:faculty_list/faculty_list.dart' hide TextLocalizer;
import 'package:group_selection/group_selection.dart' hide TextLocalizer;
import 'package:error_bloc/error_bloc.dart';
import 'package:user_sync/user_sync.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/main_firestore_repository.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/timetable_firestore_repository_factory.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';
import 'package:zhytomyr_polytechnic/widgets/dependencies.dart';
import 'package:zhytomyr_polytechnic/widgets/screens/authentication_screen.dart';

class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Color(0xff35b9ca),
          focusColor: Color(0xfff8eb4d),
          disabledColor: Color(0xffeeeeee),
          accentColor: Color(0xfff8f3b3),
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
          ),
        ),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        initialRoute: '/authentication',
        routes: <String, WidgetBuilder>{
          '/authentication': (context) => AuthenticationScreen(),
          '/faculties': (context) => FacultyList(
                facultyRepository: FirestoreRepository(),
                sidebarAction: () {},
                textLocalizer: TextLocalizer(),
                errorSink: context.read<ErrorBloc>().errorSink,
              ),
          '/group': (context) => GroupSelectionScreen(
                userIdStream: context
                    .read<AuthenticationBloc>()
                    .user
                    .map((user) => user != null ? user.uid : null),
                groupsLoader: FirestoreRepository(),
                textLocalizer: TextLocalizer(),
                errorSink: context.read<ErrorBloc>().errorSink,
                subscribeCallback:
                    context.read<UserSyncBloc>().updateUserData,
              ),
          '/timetable': (context) => TimetableScreen(
                timetableRepositoryFactory:
                    TimetableFirestoreRepositoryFactory(),
                textLocalizer: TextLocalizer(),
                errorSink: context.read<ErrorBloc>().errorSink,
                groupRepository: FirestoreRepository(),
              ),
        },
      ),
    );
  }
}
