import 'package:flutter/material.dart';

import 'default_shimmer.dart';

class FacultyIconShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultShimmer(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).disabledColor),
            width: 150,
            height: 150,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).disabledColor,
            ),
            width: 45,
            height: 23,
          ),
        ),
      ],
    );
  }
}
