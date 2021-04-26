import 'package:flutter/material.dart';

import 'package:contacts/src/widgets/components/contact_item_wrapper.dart';

class SocialNetworkContainer extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback? onTap;

  const SocialNetworkContainer({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ContactItemWrapper(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Text(
              text,
              style: Theme.of(context).textTheme.headline2,
              textScaleFactor: 1.1,
            ),
            Icon(
              Icons.navigate_next_outlined,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
