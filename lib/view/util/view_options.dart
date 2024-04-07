import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class CustomTextField extends ConsumerWidget {
  final String? label;
  final Widget? icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLength;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.label,
      this.icon,
      this.keyboardType = TextInputType.number,
      this.maxLength});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: Row(
          children: [
            if (icon != null) icon!,
            if (label != null) Text(label!),
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
            Padding(
              padding: const EdgeInsets.all(ConstList.padding),
              child: Text(label),
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
