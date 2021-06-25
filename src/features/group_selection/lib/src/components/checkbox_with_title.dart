import 'package:flutter/material.dart';

class CheckboxWithTitle extends StatelessWidget {
  final bool value;
  final Function(bool?) onChange;
  final String title;

  CheckboxWithTitle({
    required this.value,
    required this.onChange,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChange,
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: Text(title),
          ),
          onTap: () {
            onChange(!value);
          },
        ),
      ],
    );
  }
}
