import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class CustomTextField extends ConsumerWidget {
  final String? label;
  final String? subLabel;
  final Widget? icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final double? forceWidth;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.label,
      this.subLabel,
      this.icon,
      this.keyboardType = TextInputType.number,
      this.maxLength,
      this.forceWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget? labelWidget;
    if (label != null && subLabel != null) {
      labelWidget = Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(label!),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                subLabel!,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: const Color(0xFF666666)),
              )),
        ],
      );
    } else if (label != null) {
      labelWidget = Text(label!);
    }
    return SizedBox(
      width: forceWidth,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(ConstList.padding),
          child: Row(
            children: [
              if (icon != null) icon!,
              if (labelWidget != null) labelWidget,
              Expanded(
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
    );
  }
}

class CustomDropdownButton<T> extends ConsumerWidget {
  final String label;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final T value;

  const CustomDropdownButton(
      {super.key,
      required this.label,
      this.onChanged,
      required this.value,
      required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: Row(
          children: [
            Text(label),
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
        ),
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
