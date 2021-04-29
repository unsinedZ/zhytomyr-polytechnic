import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:google_authentication/google_authentication.dart';
import 'package:terms_and_conditions/terms_and_conditions.dart';
import 'package:timetable/timetable.dart' hide TextLocalizer;
import 'package:faculty_list/faculty_list.dart' hide TextLocalizer;
import 'package:group_selection/group_selection.dart' hide TextLocalizer;
import 'package:navigation_drawer/navigation_drawer.dart' hide TextLocalizer;
import 'package:contacts/contacts.dart' hide TextLocalizer;
import 'package:error_bloc/error_bloc.dart';
import 'package:user_sync/user_sync.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/main_firestore_repository.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/timetable_firestore_repository_factory.dart';
import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';
import 'package:zhytomyr_polytechnic/widgets/components/verify_authentication.dart';
import 'package:zhytomyr_polytechnic/widgets/dependencies.dart';
import 'package:zhytomyr_polytechnic/widgets/screens/authentication_screen.dart';
import 'package:zhytomyr_polytechnic/widgets/with_startup_actions.dart';

import 'components/my_timetable_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dependencies(
      child: WithStartupActions(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          initialRoute: '/authentication',
          routes: <String, WidgetBuilder>{
            '/authentication': (context) => AuthenticationScreen(),
            '/terms&conditions': (context) => TermsAndConditionsScreen(),
            '/faculties': (context) => VerifyAuthentication(
                  child: FacultyList(
                    facultyRepository: FirestoreRepository(),
                    textLocalizer: TextLocalizer(),
                    errorSink: context.read<ErrorBloc>().errorSink,
                    drawer: NavigationDrawer(
                      onSignOut: context.read<GoogleAuthenticationBloc>().logout,
                      textLocalizer: TextLocalizer(),
                      errorSink: context.read<ErrorBloc>().errorSink,
                    ),
                  ),
                ),
            '/group': (context) => GroupSelectionScreen(
                  groupsLoader: FirestoreRepository(),
                  textLocalizer: TextLocalizer(),
                  errorSink: context.read<ErrorBloc>().errorSink,
                  subscribeCallback: context.read<UserSyncBloc>().updateUserData,
                ),
            '/timetable': (context) => TimetableScreen(
                  timetableRepositoryFactory:
                      TimetableFirestoreRepositoryFactory(),
                  textLocalizer: TextLocalizer(),
                  errorSink: context.read<ErrorBloc>().errorSink,
                  groupRepository: FirestoreRepository(),
              userDataStream: context
                      .read<UserSyncBloc>()
                      .mappedUser
                      .where((user) => user != null && !user.isEmpty)
                      .map((user) => user!.data),
                ),
            '/my-timetable': (context) => MyTimetableScreen(
              timetableRepositoryFactory:
              TimetableFirestoreRepositoryFactory(),
              textLocalizer: TextLocalizer(),
              errorSink: context.read<ErrorBloc>().errorSink,
              groupRepository: FirestoreRepository(),
              userDataStream: context
                  .read<UserSyncBloc>()
                  .mappedUser
                  .where((user) => user != null && !user.isEmpty)
                  .map((user) => user!.data),
            ),
            '/contacts': (context) => ContactsScreen(
                  textLocalizer: TextLocalizer(),
                  contactsRepository: FirestoreRepository(),
                  errorSink: context.read<ErrorBloc>().errorSink,
                ),
          },
        ),
      ),
    );
  }
}
