import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class CircleButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final Tuple2<double, double> size;

  const CircleButton(
      {required this.onPressed,
      required this.child,
      this.size = const Tuple2(30, 36),
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: ConstList.isSmallDisplay(context) ? size.item1 : size.item2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(1),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
