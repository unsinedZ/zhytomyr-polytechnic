import 'package:flutter/material.dart';

import 'default_shimmer.dart';

class ContainerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultShimmer(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).disabledColor),
          width: double.infinity,
          height: 70,
        ),
      ),
    );
}
