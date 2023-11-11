import 'package:cyoap_flutter/i18n.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewColorPicker extends ConsumerWidget {
  final String? text;
  final ValueChanged<Color> onColorChanged;
  final Color color;
  const ViewColorPicker({this.text, required this.onColorChanged, required this.color, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColorPicker(
      heading: text == null ? null : Center(
        child: Text(text!),
      ),
      color: color,
      onColorChanged: onColorChanged,
      pickersEnabled: {
        ColorPickerType.wheel: true,
        ColorPickerType.accent: false
      },
      pickerTypeLabels: {
        ColorPickerType.primary: "color_select".i18n,
        ColorPickerType.wheel: "color_direct_select".i18n
      },
      width: 22,
      height: 22,
      borderRadius: 22,
    );
  }
}
