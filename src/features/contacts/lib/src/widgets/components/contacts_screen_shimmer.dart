import 'package:flutter/material.dart';

import 'container_shimmer.dart';

class ContactsScreenShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ContainerShimmer(),
        ContainerShimmer(),
        SizedBox(
          height: 20,
        ),
        ContainerShimmer(),
        ContainerShimmer(),
        ContainerShimmer(),
      ],
    );
  }
}
