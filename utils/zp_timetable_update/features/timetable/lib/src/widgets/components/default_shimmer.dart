import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class DefaultShimmer extends StatelessWidget {
  final Widget child;

  DefaultShimmer({required this.child});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Theme.of(context).disabledColor,
      highlightColor: Theme.of(context).canvasColor,
      child: child,
    );
}
