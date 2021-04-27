import 'package:flutter/material.dart';

class ContactItemWrapper extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  ContactItemWrapper({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 65,
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey.withOpacity(0.5))),
      ),
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
