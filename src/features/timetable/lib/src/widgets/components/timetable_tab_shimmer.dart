import 'package:flutter/material.dart';

import 'activity_card_shimmer.dart';
import 'default_shimmer.dart';

class TimetableTabShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: DefaultShimmer(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
              ),
              width: 100,
              height: 26,
            ),
          ),
        ),
        ActivityCardShimmer(),
      ],
    );
  }
}
