import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:error_bloc/error_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timetable/timetable.dart';
import 'package:update_form/update_form.dart';

class WithStartupAction extends StatefulWidget {
  final Widget child;

  WithStartupAction({Key? key, required this.child}) : super(key: key);

  @override
  _WithStartupActionState createState() => _WithStartupActionState();
}

class _WithStartupActionState extends State<WithStartupAction> {
  @override
  void initState() {
    context.read<UpdateFormBloc>().onUpdateCreated.listen((_) {
      AuthorizationBloc authorizationBloc = context.read<AuthorizationBloc>();
      context.read<TimetableBloc>().loadTimetableItemUpdates(
            authorizationBloc.tutorId.value,
            authorizationBloc.authClient.value!,
          );
    });

    context
        .read<ErrorBloc>()
        .error
        .debounceTime(Duration(milliseconds: 500))
        .listen((errorMessage) {
      BotToast.showText(text: errorMessage);
    });

    context.read<AuthorizationBloc>()..loadUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
