import 'package:error_bloc/error_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
        child: this.child,
      );

  ErrorBloc getErrorBloc(BuildContext context) => ErrorBloc();

  
}
