import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const CircleButton({required this.onPressed, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(14),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
