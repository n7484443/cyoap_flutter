import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
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
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: hasAlpha ? 420 : 360,
          child: ColorPicker(
            heading: text == null
                ? null
                : Center(
                    child: Text(text!),
                  ),
            color: color,
            onColorChanged: onColorChanged,
            pickersEnabled: {
              ColorPickerType.wheel: true,
              ColorPickerType.accent: false,
              ColorPickerType.custom: true,
            },
            pickerTypeLabels: {
              ColorPickerType.primary: "color_select".i18n,
              ColorPickerType.wheel: "color_direct_select".i18n,
            },
            recentColors: getPlatform.lastColorList.toList(),
            showRecentColors: true,
            width: 18,
            height: 18,
            borderRadius: 22,
            enableOpacity: hasAlpha,
          ),
        ),
        ViewRGBAInput(
          onColorChanged: onColorChanged,
          color: color,
          hasAlpha: hasAlpha,
        ),
      ],
    );
  }
}

class ViewRGBAInput extends ConsumerStatefulWidget {
  final ValueChanged<Color> onColorChanged;
  final Color color;
  final bool hasAlpha;

  const ViewRGBAInput(
      {required this.onColorChanged,
      required this.color,
      required this.hasAlpha,
      super.key});

  @override
  ConsumerState createState() => _ViewRGBInputState();
}

class _ViewRGBInputState extends ConsumerState<ViewRGBAInput> {
  final TextEditingController _controllerR = TextEditingController();
  final TextEditingController _controllerG = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  final TextEditingController _controllerA = TextEditingController();

  @override
  void initState() {
    updateText();
    super.initState();
  }

  void updateTextInner(TextEditingController controller, int value) {
    controller.text = value.toString();
  }

  void updateText() {
    updateTextInner(_controllerR, widget.color.red);
    updateTextInner(_controllerG, widget.color.green);
    updateTextInner(_controllerB, widget.color.blue);
    updateTextInner(_controllerA, widget.color.alpha);
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
  void didUpdateWidget(covariant ViewRGBAInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      updateText();
    }
  }

  @override
  Widget build(BuildContext context) {
    var filter = [
      FilteringTextInputFormatter.digitsOnly,
      NumericalRangeFormatter(minRange: 0, maxRange: 255)
    ];
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('Red'),
                TextField(
                  controller: _controllerR,
                  inputFormatters: filter,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    counterText: '',
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    var t = int.tryParse(value);
                    if (t != null) {
                      widget.onColorChanged(
                          widget.color.withRed(t.clamp(0, 255)));
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('Green'),
                TextField(
                  controller: _controllerG,
                  inputFormatters: filter,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    counterText: '',
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    var t = int.tryParse(value);
                    if (t != null) {
                      widget.onColorChanged(
                          widget.color.withGreen(t.clamp(0, 255)));
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('Blue'),
                TextField(
                  controller: _controllerB,
                  inputFormatters: filter,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    counterText: '',
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    var t = int.tryParse(value);
                    if (t != null) {
                      widget.onColorChanged(
                          widget.color.withBlue(t.clamp(0, 255)));
                    }
                  },
                ),
              ],
            ),
          ),
          if (widget.hasAlpha)
            Expanded(
              child: Column(
                children: [
                  const Text('Alpha'),
                  TextField(
                    controller: _controllerA,
                    inputFormatters: filter,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (String value) {
                      var t = int.tryParse(value);
                      if (t != null) {
                        widget.onColorChanged(
                            widget.color.withAlpha(t.clamp(0, 255)));
                      }
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int minRange;
  final int maxRange;

  NumericalRangeFormatter({required this.minRange, required this.maxRange});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    var next = int.parse(newValue.text).clamp(minRange, maxRange);
    var output = TextEditingValue(
        composing: newValue.composing,
        selection: newValue.selection.copyWith(
          baseOffset:
              newValue.selection.baseOffset.clamp(0, 3),
          extentOffset:
              newValue.selection.extentOffset.clamp(0, 3),
        ),
        text: next.toString());
    return output;
  }
}

class ViewColorOptionEditor extends StatefulWidget {
  final bool hasAlpha;
  final ColorOption colorOption;
  final void Function(ColorOption after) changeFunction;

  const ViewColorOptionEditor(
      {required this.colorOption,
      required this.changeFunction,
      this.hasAlpha = true,
      super.key});

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

  Widget _buildPoint(BuildContext context) {
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
                        Icons.circle,
                        color: Colors.red,
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
            onTapDown: (TapDownDetails? tapDownDetails) {
              setState(() {
                x = tapDownDetails!.localPosition.dx / size;
                y = tapDownDetails.localPosition.dy / size;
                x = x.clamp(0, 1);
                y = y.clamp(0, 1);
              });
              widget.changeFunction(widget.colorOption
                  .changeGradientPosition(widget.currentIndex, x, y));
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.colorOption.gradientType == GradientType.linear) {
      return _buildPoint(context);
    }
    if (widget.colorOption.gradientType == GradientType.radial &&
        widget.currentIndex == 0) {
      return _buildPoint(context);
    }
    if (widget.colorOption.gradientType == GradientType.sweep &&
        widget.currentIndex == 0) {
      return _buildPoint(context);
    }
    if (widget.colorOption.gradientType == GradientType.radial) {
      x = widget.colorOption.gradientData[widget.currentIndex].gradientPos.$1;
      var max = 1.0;
      return Slider(
        value: x.clamp(0, max),
        min: 0,
        max: max,
        onChanged: (double value) {
          setState(() {
            x = value;
          });
          widget.changeFunction(widget.colorOption
              .changeGradientPosition(widget.currentIndex, x, y));
        },
        onChangeEnd: (double value) {
          setState(() {
            x = value;
          });
          widget.changeFunction(widget.colorOption
              .changeGradientPosition(widget.currentIndex, x, y));
        },
        label: x.toString(),
        divisions: 80,
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
      );
    }
    x = widget.colorOption.gradientData[widget.currentIndex].gradientPos.$1;
    var max = 360.0;
    return Slider(
      value: x.clamp(0, max),
      min: 0,
      max: max,
      onChanged: (double value) {
        setState(() {
          x = value;
        });
        widget.changeFunction(widget.colorOption
            .changeGradientPosition(widget.currentIndex, x, y));
      },
      onChangeEnd: (double value) {
        setState(() {
          x = value;
        });
        widget.changeFunction(widget.colorOption
            .changeGradientPosition(widget.currentIndex, x, y));
      },
      label: x.round().toString(),
      divisions: 360,
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
    );
  }
}
