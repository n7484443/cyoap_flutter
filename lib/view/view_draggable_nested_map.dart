import 'dart:math';

import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_selected_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/image_db.dart';
import '../viewModel/preset/vm_choice_line_preset.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_draggable_nested_map.dart';
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
            ref
                .read(vmDraggableNestedMapProvider)
                .addData(pos, ref.read(removedChoiceNode)!.clone());
          } else if (pos.equalExceptLast(drag) &&
              (pos.data.last - 1) >= drag.last) {
            ref
                .read(vmDraggableNestedMapProvider)
                .changeData(drag, Pos(data: List.from(pos.data)..last -= 1));
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

  @override
  void initState() {
    _textFieldController = TextEditingController(
        text: ref
                .read(lineProvider(widget.y))
                ?.recursiveStatus
                .conditionVisibleString ??
            "");
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var maxSelect = ref.watch(lineMaxSelectProvider(widget.y));
    var maxSelectString = maxSelect == -1 ? "max" : maxSelect.toString();
    return AlertDialog(
      title: Text('Variable name : lineSetting_${widget.y}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Number of selections available'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  ref
                      .read(lineMaxSelectProvider(widget.y).notifier)
                      .update((state) => state >= 0 ? state - 1 : state);
                },
              ),
              Text(maxSelectString),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  ref
                      .read(lineMaxSelectProvider(widget.y).notifier)
                      .update((state) => state += 1);
                },
              ),
            ],
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Preset settings'),
            items: ref
                .watch(choiceLinePresetListProvider)
                .map<DropdownMenuItem<String>>((preset) => DropdownMenuItem(
                    value: preset.name, child: Text(preset.name)))
                .toList(),
            onChanged: (String? t) {
              if (t != null) {
                ref
                    .read(linePresetNameProvider(widget.y).notifier)
                    .update((state) => t);
              }
            },
            value: ref.watch(linePresetNameProvider(widget.y)),
          ),
          TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
                hintText: 'Visible condition (visible when true, true when empty)'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(_textFieldController!.text);
            },
            child: const Text("Confirm"))
      ],
    );
  }
}

class NodeDivider extends ConsumerWidget {
  final int y;

  const NodeDivider(this.y, {super.key});

  Color getColorLine(bool alwaysVisible, int? color) {
    if (y < getPlatform.lineSettings.length && !alwaysVisible) {
      return Colors.blueAccent;
    }
    if (color == null) {
      return Colors.white54;
    }
    if (Color(color).computeLuminance() > 0.5) {
      return Colors.black45;
    }
    return Colors.white54;
  }

  Color getColorButton(int? color) {
    if (color == null) {
      return Colors.white;
    }
    return Color(color).computeLuminance() > 0.5 ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (y >= getPlatform.lineSettings.length) {
      return const Divider(
        thickness: 4,
      );
    }
    var preset = ref.watch(linePresetProvider(y));
    if (!preset.alwaysVisibleLine && !isEditable) {
      return const SizedBox.shrink();
    }
    var maxSelect = ref.watch(lineMaxSelectProvider(y));
    var divider = Divider(
      thickness: 4,
      color: getColorLine(preset.alwaysVisibleLine, preset.backgroundColor),
    );
    Widget inner;
    if (isEditable) {
      inner = Stack(
        alignment: Alignment.center,
        children: [
          divider,
          Visibility(
            visible: maxSelect != -1,
            child: Text(
              'Max $maxSelect number of selections',
              style: ConstList.getFont("notoSans").copyWith(
                fontSize: 18.0,
                color: getColorButton(preset.backgroundColor),
                fontWeight: FontWeight.bold,
              ),
            )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (result) {
                if (result == 0) {
                  showDialog<String>(
                          context: context,
                          builder: (_) => NodeDividerDialog(y),
                          barrierDismissible: false)
                      .then((value) {
                    getPlatform
                        .getLineSetting(y)
                        ?.recursiveStatus
                        .conditionVisibleString = value!;
                    ref.read(draggableNestedMapChangedProvider.notifier).state =
                        true;
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('Line settings'),
                  ),
                ];
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward,
                      color: getColorButton(preset.backgroundColor)),
                  onPressed: () {
                    ref.read(vmDraggableNestedMapProvider).moveLine(y, y - 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward,
                      color: getColorButton(preset.backgroundColor)),
                  onPressed: () {
                    ref.read(vmDraggableNestedMapProvider).moveLine(y, y + 1);
                  },
                ),
              ],
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
            visible: maxSelect != -1,
            child: Text(
              'Max $maxSelect number of selections',
              style: ConstList.getFont("notoSans").copyWith(
                fontSize: 18.0,
                color: getColorButton(preset.backgroundColor),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
    if (preset.backgroundColor == null) {
      return inner;
    }
    return ColoredBox(color: Color(preset.backgroundColor!), child: inner);
  }
}

class NestedScroll extends ConsumerWidget {
  const NestedScroll({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var background = ref.watch(backgroundProvider);
    var backgroundAttribute = ref.watch(backgroundAttributeProvider);

    BoxFit backgroundBoxFit = BoxFit.contain;
    ImageRepeat backgroundRepeat = ImageRepeat.noRepeat;
    switch (backgroundAttribute) {
      case ImageAttribute.fill:
        backgroundBoxFit = BoxFit.cover;
        break;
      case ImageAttribute.fit:
        backgroundBoxFit = BoxFit.contain;
        break;
      case ImageAttribute.pattern:
        backgroundBoxFit = BoxFit.contain;
        backgroundRepeat = ImageRepeat.repeat;
        break;
      case ImageAttribute.stretch:
        backgroundBoxFit = BoxFit.fill;
        break;
    }
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white,
            Colors.white,
            Colors.white.withOpacity(0.05),
          ],
          stops: [0, 0.08, 0.92, 1],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Container(
        decoration: BoxDecoration(
          image: background != null
              ? DecorationImage(
                  image: Image.memory(ImageDB().getImage(background)!).image,
                  fit: backgroundBoxFit,
                  repeat: backgroundRepeat,
                  filterQuality: FilterQuality.high,
                )
              : null,
        ),
        child: const NestedMap(),
      ),
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
  ScrollController? _scrollController;

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
      sliverList = List.generate(lineList.length * 2, (index) {
        var y = lineList[index ~/ 2];
        var pos = Pos(data: [y]);
        if (index.isEven) {
          return SliverToBoxAdapter(
            child: NodeDivider(y),
          );
        }
        if (ref.watch(childrenChangeProvider(pos)).isEmpty) {
          return SliverToBoxAdapter(
            child: NodeDragTarget(
              pos.addLast(0),
              isHorizontal: true,
            ),
          );
        }
        return ViewWrapCustomReorderable(
          pos,
          isInner: false,
        );
      });
      sliverList.add(
        SliverToBoxAdapter(
          child: Visibility(
            visible: ref.watch(dragChoiceNodeProvider) != null,
            child: NodeDragTarget(
              Pos(data: [lineLength]).addLast(0),
              isHorizontal: true,
            ),
          ),
        ),
      );
    } else {
      for (int index = 0; index < lineList.length; index++) {
        var y = lineList[index];
        var pos = Pos(data: [y]);
        if (ref.watch(childrenChangeProvider(pos)).isEmpty) {
          continue;
        }
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
                        const SnackBar(
                          content: Text('No options selected'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: const Text("Summary"),
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

    return CustomScrollView(
      controller: _scrollController,
      slivers: sliverList,
    );
  }
}
