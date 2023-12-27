import 'dart:math';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_circle_button.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_selected_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../viewModel/preset/vm_choice_line_preset.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_global_setting.dart';
import '../viewModel/vm_selected_grid.dart';

class NodeDragTarget extends ConsumerWidget {
  final Pos pos;
  final Color baseColor = Colors.black12;
  final bool isHorizontal;

  const NodeDragTarget(this.pos, {this.isHorizontal = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(dragChoiceNodeProvider) != null,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: DragTarget<Pos>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          return Container(
            color: baseColor,
            height: isHorizontal ? 200 : null,
          );
        },
        onWillAccept: (Pos? drag) {
          return drag != null && !drag.contain(pos);
        },
        onAccept: (Pos drag) {
          if (drag.last == nonPositioned) {
            ref.read(vmDraggableNestedMapProvider).changeData(drag, pos);
          } else if (drag.last == removedPositioned) {
            ref.read(vmDraggableNestedMapProvider).addData(
                pos, ref
                .read(removedChoiceNodeProvider)
                .choiceNode!
                .clone());
          } else if (drag.last == copiedPositioned) {
            ref.read(vmDraggableNestedMapProvider).addData(
                pos, ref
                .read(copiedChoiceNodeProvider)
                .choiceNode!
                .clone());
          } else if (pos.equalExceptLast(drag) &&
              (pos.data.last - 1) >= drag.last) {
            ref
                .read(vmDraggableNestedMapProvider)
                .changeData(drag, Pos(data: List.from(pos.data)
              ..last -= 1));
          } else {
            ref.read(vmDraggableNestedMapProvider).changeData(drag, pos);
          }
        },
      ),
    );
  }
}

class NodeDividerDialog extends ConsumerStatefulWidget {
  final int y;

  const NodeDividerDialog(
    this.y, {
    super.key,
  });

  @override
  ConsumerState createState() => _NodeDividerDialogState();
}

class _NodeDividerDialogState extends ConsumerState<NodeDividerDialog> {
  TextEditingController? _textFieldController;
  TextEditingController? _nameController;

  @override
  void initState() {
    _textFieldController = TextEditingController(
        text: ref
                .read(lineProvider(widget.y))
                ?.recursiveStatus
                .conditionVisibleString ??
            "");
    _nameController = TextEditingController(
        text: ref.read(lineOptionProvider(widget.y)).name ??
            "ChoiceLine_${widget.y}");
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController?.dispose();
    _nameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lineOption = ref.watch(lineOptionProvider(widget.y));
    var maxSelectString =
        lineOption.maxSelect == -1 ? "max" : lineOption.maxSelect.toString();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('lineSetting_tooltip_0'.i18n),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  ref.read(lineOptionProvider(widget.y).notifier).update(
                      (state) => state.copyWith(
                          maxSelect: state.maxSelect >= 0
                              ? state.maxSelect - 1
                              : state.maxSelect));
                },
              ),
              Text(maxSelectString),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  ref.read(lineOptionProvider(widget.y).notifier).update(
                      (state) =>
                          state.copyWith(maxSelect: state.maxSelect + 1));
                },
              ),
            ],
          ),
          DropdownButtonFormField<String>(
            decoration:
                InputDecoration(labelText: 'preset_setting_tooltip'.i18n),
            items: ref
                .watch(choiceLinePresetListProvider)
                .map<DropdownMenuItem<String>>((preset) => DropdownMenuItem(
                    value: preset.name, child: Text(preset.name)))
                .toList(),
            onChanged: (String? t) {
              if (t != null) {
                ref
                    .read(lineOptionProvider(widget.y).notifier)
                    .update((state) => state.copyWith(presetName: t));
              }
            },
            value: ref.watch(lineOptionProvider(widget.y)).presetName,
          ),
          TextField(
            controller: _textFieldController,
            decoration:
                InputDecoration(hintText: 'visible_condition_tooltip'.i18n),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'lineSetting_tooltip_2'.i18n),
          ),
          ViewSwitchLabel(() {
            ref.read(lineOptionProvider(widget.y).notifier).update((state) =>
                state.copyWith(
                    enableCancelFeature: !state.enableCancelFeature));
          }, lineOption.enableCancelFeature,
              label: 'lineSetting_tooltip_3'.i18n),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(
                  Tuple2(_textFieldController!.text, _nameController!.text));
            },
            child: Text("confirm".i18n))
      ],
    );
  }
}

class NodeDivider extends ConsumerWidget {
  final int y;

  const NodeDivider(this.y, {super.key});

  Color getColorLine(bool alwaysVisible) {
    if (y < getPlatform.lineSettings.length && !alwaysVisible) {
      return Colors.blueAccent;
    }
    return Colors.white54;
  }

  Color getColorButton() {
    return Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lineOption = ref.watch(lineOptionProvider(y));
    if (y >= getPlatform.lineSettings.length) {
      return const Divider(
        thickness: 4,
      );
    }
    var preset = ref.watch(linePresetProvider(y));
    if (!preset.alwaysVisibleLine && !isEditable) {
      return const SizedBox.shrink();
    }
    var divider = Divider(
      thickness: 4,
      color: getColorLine(preset.alwaysVisibleLine),
    );
    Widget inner;
    if (isEditable) {
      inner = Stack(
        alignment: Alignment.center,
        children: [
          divider,
          if (lineOption.maxSelect != -1)
            Card(
              elevation: 0,
              color: getColorButton(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'lineSetting_tooltip_1'
                      .i18n
                      .fill([lineOption.maxSelect.toString()]),
                  style: ConstList.getFont("notoSans").copyWith(
                    fontSize: 16.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Card(
            elevation: 0,
            color: ref.watch(themeStateProvider) == ThemeMode.light
                ? Colors.white70
                : Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: [
                  CircleButton(
                    onPressed: () {
                      ref
                          .read(lineFoldProvider(y).notifier)
                          .update((state) => !state);
                    },
                    child: ref.watch(lineFoldProvider(y))
                        ? const Icon(
                            Icons.unfold_more,
                          )
                        : const Icon(
                            Icons.unfold_less,
                          ),
                  ),
                  const Spacer(),
                  if (lineOption.name != null && isEditable)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        lineOption.name!,
                        style: ConstList.getFont("notoSans").copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  CircleButton(
                    onPressed: () {
                      ref.read(vmDraggableNestedMapProvider).moveLine(y, y - 1);
                    },
                    child: const Icon(
                      Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  CircleButton(
                    onPressed: () {
                      ref.read(vmDraggableNestedMapProvider).moveLine(y, y + 1);
                    },
                    child: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  CircleButton(
                    onPressed: () async {
                      var value = await showDialog<Tuple2<String, String>>(
                          context: context,
                          builder: (_) => NodeDividerDialog(y),
                          barrierDismissible: false);
                      getPlatform
                          .getLineSetting(y)
                          ?.recursiveStatus
                          .conditionVisibleString = value!.item1;
                      ref.read(lineOptionProvider(y).notifier).update(
                          (state) => state.copyWith(name: value!.item2));
                      ref
                          .read(draggableNestedMapChangedProvider.notifier)
                          .state = true;
                      ref.invalidate(lineProvider(y));
                    },
                    child: const Icon(
                      Icons.settings,
                    ),
                  ),
                  CircleButton(
                    onPressed: () async {
                      await showDialog<bool?>(
                          context: context,
                          builder: (_) => ViewWarningDialog(
                            acceptFunction: () {
                              getPlatform.removeChoiceLine(y);
                              ref
                                  .read(draggableNestedMapChangedProvider.notifier)
                                  .state = true;
                              ref.read(refreshPageProvider);
                            },
                            cancelFunction: (){},
                            content: 'warning_message_line_delete'.i18n,
                          ),
                          barrierDismissible: false);
                    },
                    child: const Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      inner = Stack(
        alignment: Alignment.center,
        children: [
          divider,
          Visibility(
            visible: lineOption.maxSelect != -1,
            child: Text(
              'lineSetting_tooltip_1'.fill([lineOption.maxSelect]),
              style: ConstList.getFont("notoSans").copyWith(
                fontSize: 18.0,
                color: getColorButton(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
    return inner;
  }
}

class NestedScroll extends ConsumerWidget {
  const NestedScroll({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var designSetting = ref.watch(platformDesignSettingProvider);
    return Container(
      decoration: BoxDecoration(
        color: designSetting.backgroundColorOption.getColor(),
        gradient: designSetting.backgroundColorOption.getGradient(),
        image: ref.watch(platformDesignSettingImageDecorationProvider),
      ),
      child: const NestedMap(),
    );
  }
}

class NestedMap extends ConsumerStatefulWidget {
  const NestedMap({
    super.key,
  });

  @override
  ConsumerState createState() => _NestedMapState();
}

class _NestedMapState extends ConsumerState<NestedMap> {
  AdjustableScrollController? _scrollController;

  void dragUpdate(double? pos) {
    if (pos == null) return;
    var maxHeight = MediaQuery.of(context).size.height;
    double topY = 0;
    double bottomY = topY + maxHeight;

    var detectedRange = maxHeight * 0.06;
    var moveDistance = ConstList.isSmallDisplay(context) ? 0.8 : 1;
    if (pos < topY + detectedRange) {
      _scrollController!
          .jumpTo(max(_scrollController!.offset - moveDistance, 0));
    }
    if (pos > bottomY - detectedRange) {
      _scrollController!.jumpTo(_scrollController!.offset + moveDistance);
    }
  }

  @override
  void initState() {
    _scrollController = AdjustableScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<double?>(
        dragPositionProvider, (previous, next) => dragUpdate(next));
    var lineList = ref.watch(lineListProvider);
    var lineLength = ref.watch(lineLengthProvider);
    List<Widget> sliverList = [];
    if (isEditable) {
      if (lineLength == 0) {
        sliverList = [
          const SliverToBoxAdapter(
            child: NodeDivider(0),
          ),
          SliverToBoxAdapter(
            child: Card(
              child: CircleButton(
                onPressed: () {
                  ref.read(vmDraggableNestedMapProvider).addData(
                      const Pos(data: [0, 0]), ChoiceNode.empty()..width = 3);
                },
                tooltip: 'create_tooltip'.i18n,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ];
      } else {
        sliverList = List.generate(lineList.length * 2, (index) {
          var y = lineList[index ~/ 2];
          var pos = Pos(data: [y]);
          if (index.isEven) {
            return SliverToBoxAdapter(
              child: NodeDivider(y),
            );
          }
          if (ref.watch(lineFoldProvider(y))) {
            return const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            );
          }
          return ViewWrapCustomReorder(
            pos,
            isInner: false,
            maxSize: ref.watch(maximumSizeProvider),
          );
        });
        sliverList.addAll([
          SliverToBoxAdapter(
            child: Visibility(
              visible: ref.watch(dragChoiceNodeProvider) != null,
              child: NodeDivider(lineLength),
            ),
          ),
          SliverToBoxAdapter(
            child: NodeDragTarget(
              Pos(data: [lineLength]).addLast(0),
              isHorizontal: true,
            ),
          ),
        ]);
      }
    } else {
      for (int index = 0; index < lineList.length; index++) {
        var y = lineList[index];
        var pos = Pos(data: [y]);
        if (ref.watch(lineProvider(y)) != null &&
            !ref.watch(lineVisibleProvider(pos))!) {
          continue;
        }
        sliverList.add(SliverToBoxAdapter(
          child: NodeDivider(y),
        ));
        sliverList.add(
          ViewWrapCustom(
            pos,
            (i) => ViewChoiceNode(pos.addLast(i)),
            isInner: false,
            maxSize: ref.watch(maximumSizeProvider),
          ),
        );
      }
      sliverList.add(
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    if (ref.watch(selectedChoiceNodeProvider).isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const ViewSelectedGrid(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('summary_error'.i18n),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: Text("summary".i18n),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      );
    }

    if (ConstList.isSmallDisplay(context) && ref.watch(forceWideProvider)) {
      return HorizontalScrollSingleChild(
        child: Scrollbar(
          trackVisibility: true,
          controller: _scrollController,
          child: SizedBox(
            width: 1000,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: sliverList,
            ),
          ),
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: sliverList,
    );
  }
}
