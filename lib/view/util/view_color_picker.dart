import 'package:cyoap_flutter/i18n.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewColorPicker extends ConsumerWidget {
  final String? text;
  final ValueChanged<Color> onColorChanged;
  final Color color;
  final bool hasAlpha;

  const ViewColorPicker(
      {this.text,
      required this.onColorChanged,
      required this.color,
      required this.hasAlpha,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ColorPicker(
          heading: text == null
              ? null
              : Center(
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
          enableOpacity: hasAlpha,
        ),
        const SizedBox(
          height: 6,
        ),
        ViewRGBTInput(
          onColorChanged: onColorChanged,
          color: color,
          hasAlpha: hasAlpha,
        ),
      ],
    );
  }
}

class ViewRGBTInput extends ConsumerStatefulWidget {
  final ValueChanged<Color> onColorChanged;
  final Color color;
  final bool hasAlpha;

  const ViewRGBTInput(
      {required this.onColorChanged,
      required this.color,
      required this.hasAlpha,
      super.key});

  @override
  ConsumerState createState() => _ViewRGBInputState();
}

class _ViewRGBInputState extends ConsumerState<ViewRGBTInput> {
  final TextEditingController _controllerR = TextEditingController();
  final TextEditingController _controllerG = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  final TextEditingController _controllerA = TextEditingController();

  void listenerR() {
    var t = int.tryParse(_controllerR.text);
    if (t != null) {
      widget.onColorChanged(widget.color.withRed(t.clamp(0, 255)));
    }
  }

  void listenerG() {
    var t = int.tryParse(_controllerG.text);
    if (t != null) {
      widget.onColorChanged(widget.color.withGreen(t.clamp(0, 255)));
    }
  }

  void listenerB() {
    var t = int.tryParse(_controllerB.text);
    if (t != null) {
      widget.onColorChanged(widget.color.withBlue(t.clamp(0, 255)));
    }
  }

  void listenerA() {
    var t = int.tryParse(_controllerA.text);
    if (t != null) {
      widget.onColorChanged(widget.color.withAlpha(t.clamp(0, 255)));
    }
  }

  @override
  void initState() {
    updateText();
    addListener();
    super.initState();
  }

  void updateText() {
    _controllerR.text = widget.color.red.toString();
    _controllerG.text = widget.color.green.toString();
    _controllerB.text = widget.color.blue.toString();
    _controllerA.text = widget.color.alpha.toString();
  }

  void removeListener() {
    _controllerR.removeListener(listenerR);
    _controllerG.removeListener(listenerG);
    _controllerB.removeListener(listenerB);
    _controllerA.removeListener(listenerA);
  }

  void addListener() {
    _controllerR.addListener(listenerR);
    _controllerG.addListener(listenerG);
    _controllerB.addListener(listenerB);
    _controllerA.addListener(listenerA);
  }

  @override
  void dispose() {
    _controllerR.dispose();
    _controllerG.dispose();
    _controllerB.dispose();
    _controllerA.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ViewRGBTInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      removeListener();
      updateText();
      addListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = 100.0;
    var height = 42.0;
    return Wrap(
      spacing: 10,
      runSpacing: 34,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width,
            maxHeight: height,
          ),
          child: TextField(
            controller: _controllerR,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLength: 3,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(
              prefixText: 'Red',
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width,
            maxHeight: height,
          ),
          child: TextField(
            controller: _controllerG,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLength: 3,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(prefixText: 'Green'),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width,
            maxHeight: height,
          ),
          child: TextField(
            controller: _controllerB,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            maxLength: 3,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(prefixText: 'Blue'),
          ),
        ),
        if (widget.hasAlpha)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: height,
            ),
            child: TextField(
              controller: _controllerA,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              maxLength: 3,
              textAlign: TextAlign.end,
              decoration: const InputDecoration(prefixText: 'Alpha'),
            ),
          ),
      ],
    );
  }
}
