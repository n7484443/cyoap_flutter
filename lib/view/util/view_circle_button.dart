import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final (double, double) size;
  final String? tooltip;

  const CircleButton({required this.onPressed, required this.child, this.size = const (40, 36), this.tooltip, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: ConstList.isSmallDisplay(context) ? size.$1 : size.$2,
      child: IconButton(
        onPressed: onPressed,
        icon: FittedBox(
          fit: BoxFit.fill,
          child: child,
        ),
        tooltip: tooltip,
      ),
    );
  }
}
