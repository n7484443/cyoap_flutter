import 'package:flutter/material.dart';

class ViewSwitchLabel extends StatelessWidget {
  final void Function() updateState;
  final bool state;
  final bool disable;
  final String label;
  final double labelSize;

  const ViewSwitchLabel(this.updateState, this.state,
      {this.label = '', this.disable = false, this.labelSize = 14.0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => updateState(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: labelSize),
          ),
          Switch(
            onChanged:
                (disable && !state) ? null : (bool value) => updateState(),
            value: state,
          ),
        ],
      ),
    );
  }
}
