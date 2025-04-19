import 'package:flutter/material.dart';
import '../utils/rocket_theme.dart';

class RocketButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const RocketButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          isPrimary ? RocketButtonStyles.primary : RocketButtonStyles.secondary,
      child: Text(label),
    );
  }
}
