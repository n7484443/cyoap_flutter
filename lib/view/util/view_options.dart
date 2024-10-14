import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class CustomTextField extends ConsumerWidget {
  final String? label;
  final String? subLabel;
  final String? tooltip;
  final Widget? icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final double? forceWidth;
  final double? outPadding;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.label,
      this.subLabel,
      this.tooltip,
      this.icon,
      this.keyboardType = TextInputType.number,
      this.maxLength,
      this.forceWidth,
      this.outPadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(outPadding ?? 0.0),
      child: SizedBox(
        width: forceWidth,
        child: Tooltip(
          message: tooltip ?? '',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(ConstList.padding),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (icon != null) icon!,
                  if (label != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(label!),
                    ),
                  if (subLabel != null)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        subLabel!,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: const Color(0xFF666666)),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      textAlign: TextAlign.end,
                      minLines: 1,
                      maxLines: 1,
                      maxLength: maxLength,
                      keyboardType: keyboardType,
                      controller: controller,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdownButton<T> extends ConsumerWidget {
  final String? label;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final bool coverCard;

  const CustomDropdownButton(
      {super.key,
      this.label,
      this.onChanged,
        this.coverCard = true,
      required this.value,
      required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var innerWidget = Row(
      children: [
        if(label != null) Text(label!),
        const Padding(
          padding: EdgeInsets.all(ConstList.padding),
        ),
        Expanded(
          child: DropdownButtonFormField<T>(
            items: items,
            onChanged: onChanged,
            value: value,
            isExpanded: true,
          ),
        ),
      ],
    );
    if(!coverCard) {
      return innerWidget;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: innerWidget,
      ),
    );
  }
}

class CustomSwitch extends ConsumerWidget {
  final void Function() updateState;
  final String label;
  final bool state;
  final bool disable;

  const CustomSwitch(
      {super.key,
      required this.updateState,
      required this.label,
      required this.state,
      this.disable = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: ViewSwitchLabel(
          updateState,
          state,
          label: label,
          disable: disable,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
