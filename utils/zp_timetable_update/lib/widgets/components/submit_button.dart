import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;
  final bool disabled;

  SubmitButton({
    required this.onTap,
    required this.text,
    required this.color,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: MaterialButton(
        minWidth: double.infinity,
        disabledColor:
            _darken(this.color, 0.25),
        onPressed: this.disabled ? null : onTap,
        color: this.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Center(
            child: Text(text, style: Theme.of(context).textTheme.headline6),
          ),
        ),
      ),
    );
  }

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
