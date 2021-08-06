import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:error_bloc/error_bloc.dart';
import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:timetable/timetable.dart';
import 'package:update_form/update_form.dart';

import 'package:zp_timetable_update/bl/repositories/main_firestore_repository.dart';
import 'package:zp_timetable_update/bl/repositories/timetable_update_repository.dart';
import 'package:zp_timetable_update/bl/repositories/tutor_timetable_firestore_repository.dart';

class Dependencies extends StatelessWidget {
  final Widget child;

  const Dependencies({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<ErrorBloc>(create: getErrorBloc),
        ],
        child: MultiProvider(
            providers: [
              Provider<AuthorizationBloc>(create: getAuthorizationBloc),
              Provider<UpdateFormBloc>(create: getUpdateFormBloc),
            ],
            child: MultiProvider(
              providers: [
                Provider<TimetableBloc>(create: getTimetableBloc),
              ],
              child: this.child,
            )),
      );

  ErrorBloc getErrorBloc(BuildContext context) => ErrorBloc();

  AuthorizationBloc getAuthorizationBloc(BuildContext context) =>
      AuthorizationBloc(
        errorSink: context.read<ErrorBloc>().errorSink,
        tutorAuthRepository: MainFirestoreRepository(),
      );

  TimetableBloc getTimetableBloc(BuildContext context) => TimetableBloc(
        errorSink: context.read<ErrorBloc>().errorSink,
        tutorRepository: MainFirestoreRepository(),
        timetableRepository: TutorTimetableFirestoreRepository(
            sharedPreferences: SharedPreferences.getInstance()),
      );

  UpdateFormBloc getUpdateFormBloc(BuildContext context) => UpdateFormBloc(
        errorSink: context.read<ErrorBloc>().errorSink,
        groupsRepository: MainFirestoreRepository(),
        timetableUpdateRepository: TimetableUpdateRepository(),
      );
}
