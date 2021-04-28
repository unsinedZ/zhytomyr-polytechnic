import 'package:flutter/material.dart';

import 'faculty_icon_shimmer.dart';
import 'default_shimmer.dart';

class FacultyListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultShimmer(
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).disabledColor),
              width: 100,
              height: 26,
            ),
          ),
        ),
        Center(
          child: Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: getFacultyIconShimmers(5),
          ),
        ),
      ],
    );
  }

  List<Widget> getFacultyIconShimmers(int count) {
    List<Widget> widgets = [];

    for (int i = 0; i < count; i++) {
      widgets.add(FacultyIconShimmer());
    }

    return widgets;
  }
}
