import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class FacultyIconShimmer extends StatelessWidget {
  const FacultyIconShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultShimmer(
          baseColor: Theme.of(context).disabledColor,
          highlightColor: Theme.of(context).canvasColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            width: 150,
            height: 150,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            width: 150,
            height: 150,
          ),
        ),
      ],
    );
  }
}
