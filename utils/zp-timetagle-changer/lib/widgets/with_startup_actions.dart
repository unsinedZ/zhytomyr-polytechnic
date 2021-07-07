import 'package:error_bloc/error_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class WithStartupAction extends StatefulWidget {
  final Widget child;

  WithStartupAction({Key? key, required this.child}) : super(key: key);

  @override
  _WithStartupActionState createState() => _WithStartupActionState();
}

class _WithStartupActionState extends State<WithStartupAction> {
  @override
  void initState() {
    context
        .read<ErrorBloc>()
        .error
        .debounceTime(Duration(milliseconds: 500))
        .listen((errorMessage) {
      Toast.show(errorMessage, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
