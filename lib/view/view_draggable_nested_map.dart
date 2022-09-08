import 'dart:math';

import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_selected_grid.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

import '../model/choiceNode/pos.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_draggable_nested_map.dart';

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
    ref.listen(lineAlwaysVisibleProvider(widget.y), (previous, bool next) {
      getPlatform.getLineSetting(widget.y)!.alwaysVisible = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(lineMaxSelectProvider(widget.y), (previous, int next) {
      getPlatform.getLineSetting(widget.y)!.maxSelect = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen<Color?>(lineBackgroundColorProvider(widget.y), (previous, next) {
      getPlatform.getLineSetting(widget.y)!.backgroundColor = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    var maxSelect = ref.watch(lineMaxSelectProvider(widget.y));
    var maxSelectString = maxSelect == -1 ? "max" : maxSelect.toString();
    return AlertDialog(
      title: Text('변수명 : lineSetting_${widget.y}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('선택 가능'),
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
          ViewSwitchLabel(
            () => ref
                .read(lineAlwaysVisibleProvider(widget.y).notifier)
                .update((state) => !state),
            ref.watch(lineAlwaysVisibleProvider(widget.y)),
            label: '항상 보임',
          ),
          ColorPicker(
            pickersEnabled: {
              ColorPickerType.both: true,
              ColorPickerType.primary: false,
              ColorPickerType.accent: false
            },
            color: const Color(0x00000000),
            onColorChanged: (color) {
              ref.read(lineBackgroundColorProvider(widget.y).notifier).state =
                  color;
            },
          ),
          IconButton(
            onPressed: () {
              ref.read(lineBackgroundColorProvider(widget.y).notifier).state =
                  null;
            },
            icon: const Icon(Icons.format_color_reset),
          ),
          TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
                hintText: '보이는 조건(true 일 때 보임, 비어있을 시 true)'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(_textFieldController!.text);
            },
            child: const Text("확인"))
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
    if (getPlatform.designSetting.colorBackground.computeLuminance() > 0.5) {
      return Colors.black45;
    }
    return Colors.white54;
  }

  Color getColorButton() {
    return getPlatform.designSetting.colorBackground.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (y >= getPlatform.lineSettings.length) {
      return const Divider(
        thickness: 4,
      );
    }
    if (!ref.watch(lineAlwaysVisibleProvider(y)) && !isEditable) {
      return const SizedBox.shrink();
    }
    var maxSelect = ref.watch(lineMaxSelectProvider(y));
    var divider = Divider(
      thickness: 4,
      color: getColorLine(ref.watch(lineAlwaysVisibleProvider(y))),
    );

    if (isEditable) {
      return Stack(
        alignment: Alignment.center,
        children: [
          divider,
          Visibility(
            visible: maxSelect != -1,
            child: TextOutline('최대 $maxSelect개만큼 선택 가능', 18.0,
                ConstList.getFont(ref.watch(titleFontProvider)),
                strokeWidth: 5.0),
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
                    child: Text('라인 설정'),
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
                  icon: Icon(Icons.arrow_upward, color: getColorButton()),
                  onPressed: () {
                    ref.read(vmDraggableNestedMapProvider).moveLine(y, y - 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward, color: getColorButton()),
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
      return Stack(
        alignment: Alignment.center,
        children: [
          divider,
          Visibility(
            visible: maxSelect != -1,
            child: TextOutline('최대 $maxSelect개만큼 선택 가능', 18.0,
                ConstList.getFont(ref.watch(titleFontProvider)),
                strokeWidth: 5.0),
          ),
        ],
      );
    }
  }
}

class NestedScroll extends ConsumerWidget {
  const NestedScroll({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: ColoredBox(
        color: ref.watch(colorBackgroundProvider),
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
    _scrollController = ScrollController();
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
    var lineLength = ref.watch(lineLengthProvider) * 2 + (isEditable ? 2 : 1);
    if (ConstList.isWeb() && !ConstList.isSmallDisplay(context)) {
      return WebSmoothScroll(
        controller: _scrollController!,
        scrollOffset: 100,
        animationDuration: 150,
        child: ListView.builder(
          key: const PageStorageKey(0),
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: lineLength,
          itemBuilder: (BuildContext context, int index) {
            var y = index ~/ 2;
            if (index.isEven) {
              if (y >= ref.watch(lineLengthProvider) && !isEditable) {
                return TextButton(
                    onPressed: () =>
                        showDialog(context: context, builder: (context) => const Dialog(
                          child: ViewSelectedGrid(),
                        )),
                    child: const Text("요약"));
              }
              return NodeDivider(y);
            }
            if (y >= ref.watch(lineLengthProvider)) {
              return Visibility(
                visible: ref.watch(dragChoiceNodeProvider) != null,
                child: NodeDragTarget(
                  Pos(data: [y]).addLast(0),
                  isHorizontal: true,
                ),
              );
            }
            var color = ref.watch(lineBackgroundColorProvider(y));
            if (color != null) {
              return ColoredBox(color: color, child: ChoiceLine(y));
            }
            return ChoiceLine(y);
          },
          cacheExtent: 200,
        ),
      );
    }

    return ListView.builder(
      key: const PageStorageKey(0),
      controller: _scrollController,
      itemCount: lineLength,
      itemBuilder: (BuildContext context, int index) {
        var y = index ~/ 2;
        if (index.isEven) {
          if (y >= ref.watch(lineLengthProvider) && !isEditable) {
            return TextButton(
                onPressed: () =>
                    showDialog(context: context, builder: (context) => const Dialog(
                      child: ViewSelectedGrid(),
                    )),
                child: const Text("요약"));
          }
          return NodeDivider(y);
        }
        if (y >= ref.watch(lineLengthProvider)) {
          return Visibility(
            visible: ref.watch(dragChoiceNodeProvider) != null,
            child: NodeDragTarget(
              Pos(data: [y]).addLast(0),
              isHorizontal: true,
            ),
          );
        }
        var color = ref.watch(lineBackgroundColorProvider(y));
        if (color != null) {
          return ColoredBox(color: color, child: ChoiceLine(y));
        }
        return ChoiceLine(y);
      },
      cacheExtent: 200,
    );
  }
}

class ChoiceLine extends ConsumerWidget {
  final int y;

  const ChoiceLine(this.y, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pos = Pos(data: [y]);
    if (ref.watch(childrenChangeProvider(pos)).isEmpty) {
      if (isEditable) {
        return NodeDragTarget(
          pos.addLast(0),
          isHorizontal: true,
        );
      } else {
        return const SizedBox.shrink();
      }
    }
    if (!isEditable && !ref.watch(lineVisibleProvider(pos))) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
      ),
      child: ViewWrapCustom(
        pos,
        (i) => ViewChoiceNode(pos.addLast(i)),
        isInner: false,
      ),
    );
  }
}
