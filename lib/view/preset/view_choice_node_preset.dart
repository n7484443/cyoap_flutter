import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:cyoap_flutter/view/util/view_vertical_tabbar.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/platform.dart';
import '../../viewModel/preset/vm_choice_node_preset.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../../viewModel/vm_choice_node.dart';
import '../util/controller_adjustable_scroll.dart';
import '../util/view_color_picker.dart';
import '../util/view_switch_label.dart';
import '../view_choice_node.dart';

class ChoiceNodeSample extends ConsumerWidget {
  const ChoiceNodeSample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: IgnorePointer(
            child: ViewChoiceNode(
              Pos(data: [designSamplePosition]),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              ref
                  .read(choiceNodePresetTestSelectProvider.notifier)
                  .update((state) => !state);
              var pos = const Pos(data: [designSamplePosition]);
              ref.invalidate(choiceNodeProvider(pos));
            },
            icon: const Icon(Icons.border_style)),
      ],
    );
  }
}

class ChoiceNodePresetList extends ConsumerWidget {
  const ChoiceNodePresetList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(choiceNodePresetListProvider);
    return Column(
      children: [
        ListTile(
          title: Text('preset'.i18n),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(choiceNodePresetListProvider.notifier).create();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: AdjustableScrollController(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              var preset = list[index];
              return ListTile(
                key: Key('$index'),
                title: Text(preset.name),
                trailing: preset.name == "default"
                    ? null
                    : IconButton(
                        icon: Icon(Icons.delete,
                            size: (IconTheme.of(context).size ?? 18) * 0.8),
                        onPressed: () {
                          ref
                              .read(choiceNodePresetListProvider.notifier)
                              .deleteIndex(index);
                        },
                      ),
                onTap: () {
                  ref
                      .read(currentPresetIndexProvider.notifier)
                      .update((state) => index);
                  var pos = const Pos(data: [designSamplePosition]);
                  ref.invalidate(choiceNodeProvider(pos));
                },
                onLongPress: () async {
                  if (preset.name == "default") return;
                  var text = await showDialog(
                      context: context,
                      builder: (context) {
                        return PresetRenameDialog(preset.name);
                      },
                      barrierDismissible: false);
                  if (text != null && text.trim().isNotEmpty) {
                    ref
                        .read(choiceNodePresetListProvider.notifier)
                        .rename(index, text.trim());
                    var pos = const Pos(data: [designSamplePosition]);
                    ref.invalidate(choiceNodeProvider(pos));
                  }
                },
                selected: index == ref.watch(currentPresetIndexProvider),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ViewTextFieldInput extends ConsumerStatefulWidget {
  final String text;
  final AutoDisposeProvider<double> provider;
  final void Function(String) inputFunction;

  const ViewTextFieldInput(
    this.text,
    this.provider,
    this.inputFunction, {
    super.key,
  });

  @override
  ConsumerState createState() => _ViewTextFieldInputState();
}

class _ViewTextFieldInputState extends ConsumerState<ViewTextFieldInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller?.addListener(() {
      EasyDebounce.debounce(widget.text, const Duration(milliseconds: 500), () {
        widget.inputFunction(_controller?.text ?? '');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.end,
      maxLength: 3,
      minLines: 1,
      maxLines: 1,
      keyboardType: TextInputType.number,
      controller: _controller,
      decoration: InputDecoration(labelText: widget.text),
    );
  }
}

class ViewNodeOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeOptionEditor({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewNodeOptionEditorState();
}

class _ViewNodeOptionEditorState extends ConsumerState<ViewNodeOptionEditor> {
  AdjustableScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = AdjustableScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentChild;
    switch (ref.watch(choiceNodePresetCurrentTabProvider)) {
      case 0:
        currentChild = const ViewNodeGeneralOptionEditor();
      case 1:
        currentChild = const ViewNodeOutlineOptionEditor();
      default:
        currentChild = const ViewNodeColorOptionEditor();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalTabBar(
          tabList: ['general'.i18n, 'outline'.i18n, 'inner'.i18n].toList(),
          isUnable: false,
          currentIndex: ref.watch(choiceNodePresetCurrentTabProvider),
          onChange: (index) {
            ref.read(choiceNodePresetCurrentTabProvider.notifier).state =
                index!;
          },
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: currentChild,
        ),
      ],
    );
  }
}

class ViewNodeGeneralOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeGeneralOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeGeneralOptionEditorState();
}

class _ViewNodeGeneralOptionEditorState
    extends ConsumerState<ViewNodeGeneralOptionEditor> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverGrid(
            delegate: SliverChildListDelegate([
              TextFormField(
                textAlign: TextAlign.end,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller:
                    ref.watch(choiceNodePresetCurrentEditElevationProvider),
                decoration: InputDecoration(labelText: 'height'.i18n),
              ),
              TextFormField(
                textAlign: TextAlign.end,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: ref.watch(choiceNodePresetCurrentEditRoundProvider),
                decoration: InputDecoration(labelText: 'round'.i18n),
              ),
              TextFormField(
                textAlign: TextAlign.end,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller:
                    ref.watch(choiceNodePresetCurrentEditPaddingProvider),
                decoration: InputDecoration(labelText: 'padding'.i18n),
              ),
              ViewSwitchLabel(
                () => ref
                    .read(choiceNodePresetListProvider.notifier)
                    .updateIndex(
                        presetIndex,
                        preset.copyWith(
                            maximizingImage: !preset.maximizingImage)),
                preset.maximizingImage,
                label: 'maximize_image'.i18n,
              ),
              ViewSwitchLabel(
                () => ref
                    .read(choiceNodePresetListProvider.notifier)
                    .updateIndex(presetIndex,
                        preset.copyWith(hideTitle: !preset.hideTitle)),
                preset.hideTitle,
                label: 'hide_title'.i18n,
              ),
              ViewSwitchLabel(
                () => ref
                    .read(choiceNodePresetListProvider.notifier)
                    .updateIndex(presetIndex,
                        preset.copyWith(titlePosition: !preset.titlePosition)),
                preset.titlePosition,
                label: 'title_up'.i18n,
              ),
              ViewSwitchLabel(
                () => ref
                    .read(choiceNodePresetListProvider.notifier)
                    .updateIndex(
                        presetIndex,
                        preset.copyWith(
                            imagePosition: preset.imagePosition == 0 ? 1 : 0)),
                preset.imagePosition != 0,
                label: 'horizontal_mode'.i18n,
              ),
              ViewSwitchLabel(
                () {
                  if (preset.imagePosition == 1) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex, preset.copyWith(imagePosition: 2));
                  } else if (preset.imagePosition == 2) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex, preset.copyWith(imagePosition: 1));
                  }
                },
                preset.imagePosition == 2,
                disable: preset.imagePosition == 0,
                label: 'image_left'.i18n,
              ),
              SizedBox(),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'font_title'.i18n),
                items: ConstList.textFontList.keys
                    .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name, style: ConstList.getFont(name))))
                    .toList(),
                onChanged: (String? t) {
                  if (t != null) {
                    var index = ref.read(currentPresetIndexProvider);
                    ref
                        .read(choiceNodePresetListProvider.notifier)
                        .updateIndex(index, preset.copyWith(titleFont: t));
                  }
                },
                value: preset.titleFont,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'font_content'.i18n),
                items: ConstList.textFontList.keys
                    .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name, style: ConstList.getFont(name))))
                    .toList(),
                onChanged: (String? t) {
                  if (t != null) {
                    var index = ref.read(currentPresetIndexProvider);
                    ref
                        .read(choiceNodePresetListProvider.notifier)
                        .updateIndex(index, preset.copyWith(mainFont: t));
                  }
                },
                value: preset.mainFont,
              )
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 3,
              crossAxisSpacing: 10,
              mainAxisExtent: 80,
              mainAxisSpacing: 2,
            ),
          )
        ],
      ),
    );
  }
}

class ViewNodeOutlineOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeOutlineOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeOutlineOptionEditorState();
}

class _ViewNodeOutlineOptionEditorState
    extends ConsumerState<ViewNodeOutlineOptionEditor> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ViewColorPicker(
              text: 'node_outline_color'.i18n,
              color: preset.outlineOption.outlineColor.getColor(),
              onColorChanged: (Color value) {
                ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                    presetIndex,
                    preset.copyWith
                        .outlineOption.outlineColor(color: value.value));
              },
            ),
          ),
          SliverGrid(
            delegate: SliverChildListDelegate([
              DropdownButtonFormField<OutlineType>(
                decoration: InputDecoration(labelText: 'outline_shape'.i18n),
                items: OutlineType.values
                    .map<DropdownMenuItem<OutlineType>>((type) =>
                        DropdownMenuItem(value: type, child: Text(type.name)))
                    .toList(),
                onChanged: (OutlineType? t) {
                  if (t != null) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex,
                        preset.copyWith.outlineOption(outlineType: t));
                  }
                },
                value: preset.outlineOption.outlineType,
              ),
              TextFormField(
                textAlign: TextAlign.end,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: ref
                    .watch(choiceNodePresetCurrentEditOutlinePaddingProvider),
                decoration: InputDecoration(labelText: 'outline_padding'.i18n),
              ),
              TextFormField(
                textAlign: TextAlign.end,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller:
                    ref.watch(choiceNodePresetCurrentEditOutlineWidthProvider),
                decoration: InputDecoration(labelText: 'outline_width'.i18n),
              ),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 3,
              crossAxisSpacing: 10,
              mainAxisExtent: 60,
              mainAxisSpacing: 2,
            ),
          )
        ],
      ),
    );
  }
}

class ViewNodeColorOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeColorOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeColorOptionEditorState();
}

class _ViewNodeColorOptionEditorState
    extends ConsumerState<ViewNodeColorOptionEditor> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ViewColorOptionEditor(
              colorOption: preset.defaultColorOption,
              changeFunction: (ColorOption after) {
                ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                    presetIndex, preset.copyWith(defaultColorOption: after));
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text('node_select_color_enable'.i18n),
                Checkbox(
                  value: preset.selectColorEnable,
                  onChanged: (bool? value) {
                    if (value != null) {
                      ref
                          .read(choiceNodePresetListProvider.notifier)
                          .updateIndex(presetIndex,
                              preset.copyWith(selectColorEnable: value));
                    }
                  },
                ),
              ],
            ),
          ),
          SliverOpacity(
            opacity: preset.selectColorEnable ? 1.0 : 0.3,
            sliver: SliverToBoxAdapter(
              child: ViewColorOptionEditor(
                colorOption: preset.selectColorOption,
                changeFunction: (ColorOption after) {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex, preset.copyWith(selectColorOption: after));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewColorOptionEditor extends StatefulWidget {
  final ColorOption colorOption;
  final void Function(ColorOption after) changeFunction;

  const ViewColorOptionEditor(
      {required this.colorOption, required this.changeFunction, super.key});

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
          color: widget.colorOption.getColor(),
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

  const ViewGradientOption(
      {required this.colorOption,
      required this.changeFunction,
      required this.currentIndexFunction,
      required this.currentIndex,
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
                selected:  index == currentIndex,
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
            changeFunction(colorOption.changeGradientColor(currentIndex, value));
          },
        )),
      ],
    );
  }
}

class ViewGradientPositionOption extends StatefulWidget {
  final ColorOption colorOption;
  final void Function(ColorOption after) changeFunction;
  final int currentIndex;
  const ViewGradientPositionOption({required this.colorOption,
    required this.changeFunction,
    required this.currentIndex,
    super.key});

  @override
  State createState() => _ViewGradientPositionOptionState();
}

class _ViewGradientPositionOptionState extends State<ViewGradientPositionOption> {
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
            widget.changeFunction(widget.colorOption.changeGradientPosition(widget.currentIndex, x, y));
          },
        ),
      ],
    );
  }
}