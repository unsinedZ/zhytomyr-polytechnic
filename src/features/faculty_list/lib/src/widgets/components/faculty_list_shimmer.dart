import 'package:flutter/material.dart';

import 'faculty_icon_shimmer.dart';
import 'default_shimmer.dart';

class FacultyListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
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
            children: List.generate(5, (index) => FacultyIconShimmer()),
          ),
        ),
      ],
    );
}
