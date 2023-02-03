import 'package:flutter/material.dart';

class ViewSwitchLabel extends StatelessWidget {
  final void Function() updateState;
  final bool state;
  final bool disable;
  final String label;
  final double labelSize;
  final bool reverse;

  const ViewSwitchLabel(this.updateState, this.state,
      {this.label = '',
      this.disable = false,
      this.labelSize = 14.0,
      this.reverse = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    var child = [
      Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontSize: labelSize),
      ),
      FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          onChanged: (disable && !state) ? null : (bool value) => updateState(),
          value: state,
        ),
      ),
    ];
    if (reverse) {
      child = child.reversed.toList();
    }
    return InkWell(
      onTap: () => updateState(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: child,
      ),
    );
  }
}
