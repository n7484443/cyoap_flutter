import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller_adjustable_scroll.dart';

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

class ViewColorOptionEditor extends StatefulWidget {
  final bool hasAlpha;
  final ColorOption colorOption;
  final void Function(ColorOption after) changeFunction;

  const ViewColorOptionEditor(
      {required this.colorOption, required this.changeFunction, this.hasAlpha = true, super.key});

  @override
  State createState() => _ViewColorOptionEditorState();
}

class _ViewColorOptionEditorState extends State<ViewColorOptionEditor> {
  int currentEditIndex = 0;

  @override
  Widget build(BuildContext context) {
    var dropdown = DropdownButtonFormField<ColorType>(
      decoration: InputDecoration(labelText: 'node_color'.i18n),
      items: ColorType.values
          .getRange(0, 2)
          .map<DropdownMenuItem<ColorType>>(
              (type) => DropdownMenuItem(value: type, child: Text(type.name)))
          .toList(),
      onChanged: (ColorType? t) {
        if (t != null) {
          widget.changeFunction(widget.colorOption.copyWith(colorType: t));
        }
      },
      value: widget.colorOption.colorType,
    );
    var dropdownGrad = DropdownButtonFormField<GradientType>(
      decoration: InputDecoration(labelText: 'grad_type'.i18n),
      items: GradientType.values
          .map<DropdownMenuItem<GradientType>>(
              (type) => DropdownMenuItem(value: type, child: Text(type.name)))
          .toList(),
      onChanged: (GradientType? t) {
        if (t != null) {
          widget.changeFunction(widget.colorOption.copyWith(gradientType: t));
        }
      },
      value: widget.colorOption.gradientType,
    );
    if (widget.colorOption.hasGradient()) {
      return Column(
        children: [
          dropdown,
          dropdownGrad,
          ViewGradientOption(
            colorOption: widget.colorOption,
            changeFunction: widget.changeFunction,
            currentIndexFunction: (int after) {
              setState(() {
                currentEditIndex = after;
              });
            },
            currentIndex: currentEditIndex,
            hasAlpha: widget.hasAlpha,
          ),
          ViewGradientPositionOption(
            colorOption: widget.colorOption,
            changeFunction: widget.changeFunction,
            currentIndex: currentEditIndex,
          ),
        ],
      );
    }
    return Column(
      children: [
        dropdown,
        ViewColorPicker(
          onColorChanged: (Color value) {
            widget.changeFunction(
                widget.colorOption.copyWith(color: value.value));
          },
          color: widget.colorOption.getColor()!,
          hasAlpha: widget.hasAlpha,
        ),
      ],
    );
  }
}


class ViewGradientOption extends StatelessWidget {
  final ColorOption colorOption;
  final void Function(ColorOption after) changeFunction;
  final void Function(int after) currentIndexFunction;
  final int currentIndex;
  final bool hasAlpha;

  const ViewGradientOption(
      {required this.colorOption,
        required this.changeFunction,
        required this.currentIndexFunction,
        required this.currentIndex,
        this.hasAlpha = true,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 300,
          child: ListView(
            controller: AdjustableScrollController(),
            shrinkWrap: true,
            children: List.generate(colorOption.gradientData.length, (index) {
              return ListTile(
                title: Text(index.toString()),
                onTap: () {
                  currentIndexFunction(index);
                },
                selected: index == currentIndex,
                selectedTileColor: Colors.blueGrey.withOpacity(0.3),
              );
            }),
          ),
        ),
        Expanded(
          child: ViewColorPicker(
            text: 'node_select_grad_color'.i18n.fill([currentIndex]),
            color: Color(colorOption.gradientData[currentIndex].color),
            onColorChanged: (Color value) {
              changeFunction(
                  colorOption.changeGradientColor(currentIndex, value));
            },
            hasAlpha: hasAlpha,
          ),
        ),
      ],
    );
  }
}

class ViewGradientPositionOption extends StatefulWidget {
  final ColorOption colorOption;
  final void Function(ColorOption after) changeFunction;
  final int currentIndex;

  const ViewGradientPositionOption(
      {required this.colorOption,
        required this.changeFunction,
        required this.currentIndex,
        super.key});

  @override
  State createState() => _ViewGradientPositionOptionState();
}

class _ViewGradientPositionOptionState
    extends State<ViewGradientPositionOption> {
  double x = 0.5;
  double y = 0.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    x = widget.colorOption.gradientData[widget.currentIndex].gradientPos.$1;
    y = widget.colorOption.gradientData[widget.currentIndex].gradientPos.$2;
    var size = 100.0;
    var iconSize = 20.0;
    return Row(
      children: [
        GestureDetector(
          child: SizedBox.square(
            dimension: size,
            child: ColoredBox(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    left: size * x - iconSize / 2,
                    top: size * y - iconSize / 2,
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: iconSize,
                    ),
                  )
                ],
              ),
            ),
          ),
          onPanUpdate: (DragUpdateDetails? dragUpdateDetails) {
            setState(() {
              x = dragUpdateDetails!.localPosition.dx / size;
              y = dragUpdateDetails.localPosition.dy / size;
              x = x.clamp(0, 1);
              y = y.clamp(0, 1);
            });
            widget.changeFunction(widget.colorOption
                .changeGradientPosition(widget.currentIndex, x, y));
          },
        ),
      ],
    );
  }
}
