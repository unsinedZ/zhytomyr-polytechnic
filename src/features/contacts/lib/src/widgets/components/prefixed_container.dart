import 'package:flutter/material.dart';

import 'package:contacts/src/widgets/components/contact_item_wrapper.dart';

class PrefixedContainer extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback? onTap;

  PrefixedContainer({required this.title, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ContactItemWrapper(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(text, style: Theme.of(context).textTheme.headline2)
          ],
        ),
      ),
    );
  }
}
