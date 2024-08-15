import 'package:flutter/material.dart';

class ViewSwitchLabel extends StatelessWidget {
  final void Function() updateState;
  final bool state;
  final bool disable;
  final String label;
  final double labelSize;
  final bool reverse;
  final MainAxisAlignment mainAxisAlignment;

  const ViewSwitchLabel(this.updateState, this.state,
      {this.label = '',
      this.disable = false,
      this.labelSize = 12.0,
      this.reverse = false,
      this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
      super.key});

  @override
  Widget build(BuildContext context) {
    var child = [
      Text(label),
      ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 28,
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Switch(
            onChanged:
                (disable && !state) ? null : (bool value) => updateState(),
            value: state,
          ),
        ),
      ),
    ];
    if (reverse) {
      child = child.reversed.toList();
    }
    return InkWell(
      onTap: () => updateState(),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: child,
      ),
    );
  }
}
