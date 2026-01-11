import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF45C4D9),
            Color(0xFF6B7FEC),
            Color(0xFF5C58EB),
            Color(0xFFB565D8),
          ],
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
