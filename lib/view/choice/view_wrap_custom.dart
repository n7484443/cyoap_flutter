import 'dart:math';

import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/line_preset.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/util/view_circle_button.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/choice/vm_choice_line.dart';
import '../../viewModel/vm_design_setting.dart';
import '../../viewModel/vm_draggable_nested_map.dart';
import 'view_choice_node.dart';

const double defaultHeight = 70.0;

class DropRegionRow extends ConsumerStatefulWidget {
  final List<Expanded> widgets;
  final List<SizeData> sizeData;
  final Pos startPos;
  final int maxChildrenPerRow;
  final bool isEmpty;

  const DropRegionRow(
      {super.key,
      required this.widgets,
      required this.sizeData,
      required this.maxChildrenPerRow,
      required this.startPos,
      this.isEmpty = false});

  @override
  ConsumerState createState() => _DropRegionRowState();
}

class _DropRegionRowState extends ConsumerState<DropRegionRow> {
  bool isEntered = false;
  int index = -1;

  void add(Pos drag, Pos target, WidgetRef ref) {
    if (drag.first < 0) {
      ref.read(choiceStatusProvider(target.removeLast()).notifier).addChoice(
          ref
              .read(choiceNodeClipboardStatusProvider)
              .choiceNodeQueue[-drag.first - 1]
              .clone(),
          index: target.last);
    } else if (target.equalExceptLast(drag) &&
        (target.data.last - 1) >= drag.last) {
      ref
          .read(choiceStatusProvider(drag).notifier)
          .swapChoice(Pos(data: List.from(target.data)..last -= 1));
    } else {
      ref.read(choiceStatusProvider(drag).notifier).swapChoice(target);
    }
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    List<Expanded> render;
    if (!(isEntered && index >= 0)) {
      render = widget.widgets;
    } else if (widget.isEmpty) {
      render = [
        Expanded(
          flex: 1,
          child: ColoredBox(
            color: Colors.redAccent.withOpacity(0.3),
            child: const SizedBox(height: defaultHeight),
          ),
        )
      ];
    } else {
      render = widget.widgets
          .map((e) => Expanded(flex: e.flex * 4, child: e.child))
          .toList();
      int i = index;
      int flex = 0;
      if (i - 1 >= 0) {
        render[i - 1] =
            Expanded(flex: render[i - 1].flex - 1, child: render[i - 1].child);
        flex += 1;
      }
      if (i < render.length) {
        render[i] = Expanded(flex: render[i].flex - 1, child: render[i].child);
        flex += 1;
      }
      render.insert(
        i,
        Expanded(
          flex: flex,
          child: ColoredBox(
            color: Colors.redAccent.withOpacity(0.3),
          ),
        ),
      );
    }
    return DropRegion(
      formats: Formats.standardFormats,
      hitTestBehavior: HitTestBehavior.opaque,
      onDropOver: (DropOverEvent event) {
        var item = event.session.items.first;
        if (item.localData is! List) {
          return DropOperation.none;
        }
        var drag = Pos(data: (item.localData as List).cast<int>());
        var mousePos = event.position;
        var width = context.size?.width ?? 0;
        var flexSum = widget.sizeData.fold<int>(0, (a, b) => a + b.width);
        var spaceWidth = width / flexSum;
        var x = mousePos.local.dx / spaceWidth;
        var minLength = 0.25;
        var before = 0;
        if (widget.sizeData.isEmpty) {
          var pos = widget.sizeData.first.pos!;
          if (drag.isParent(pos)) {
            setState(() {
              index = -1;
            });
            return DropOperation.none;
          }
          setState(() {
            index = 0;
          });
          return DropOperation.copy;
        }

        for (var index = 0; index < widget.sizeData.length; index++) {
          var sizeData = widget.sizeData[index];
          var (width, pos) = (sizeData.width, sizeData.pos);
          if (x < before) {
            setState(() {
              this.index = -1;
            });
            return DropOperation.none;
          }
          if (x > before + width) {
            before += width;
            continue;
          }
          if (pos == null) {
            Pos dragPos;
            int indexNew = index;
            if (index == 0) {
              if (index + 1 < widget.sizeData.length) {
                dragPos = widget.sizeData[index + 1].pos!;
              } else {
                dragPos = widget.startPos;
              }
              indexNew += 1;
            } else {
              dragPos = widget.sizeData[index - 1].pos!;
              indexNew -= 1;
            }
            if (drag.isParent(dragPos)) {
              setState(() {
                this.index = -1;
              });
              return DropOperation.none;
            }
            setState(() {
              this.index = indexNew;
            });
            return DropOperation.copy;
          }

          if (drag.isParent(pos)) {
            setState(() {
              this.index = -1;
            });
            return DropOperation.none;
          }

          var left = x - before;
          var right = before + width - x;
          if (0 <= left && left <= minLength) {
            setState(() {
              this.index = index;
            });
          } else if (0 <= right && right <= minLength) {
            setState(() {
              this.index = index + 1;
            });
          } else {
            setState(() {
              this.index = -1;
            });
          }
          return DropOperation.copy;
        }
        return DropOperation.none;
      },
      onPerformDrop: (PerformDropEvent event) async {
        var item = event.session.items.first;
        var data = Pos(data: (item.localData as List).cast<int>());
        if (isEntered) {
          if (index < widget.sizeData.length &&
              widget.sizeData[index].pos != null) {
            add(data, widget.sizeData[index].pos!, ref);
          } else {
            Iterator<SizeData> iterator;
            if (index == 0) {
              iterator = widget.sizeData.iterator;
            } else {
              iterator = widget.sizeData.reversed.iterator;
            }
            Pos? pos;
            while (iterator.moveNext() && pos == null) {
              pos = iterator.current.pos;
            }
            if (pos == null) {
              add(data, widget.startPos, ref);
            } else {
              add(data, pos.removeLast().addLast(pos.last + 1), ref);
            }
          }
        }
      },
      onDropEnter: (DropEvent event) {
        setState(() {
          isEntered = true;
        });
      },
      onDropLeave: (DropEvent event) {
        setState(() {
          isEntered = false;
        });
      },
      onDropEnded: (DropEvent event) {
        setState(() {
          isEntered = false;
        });
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: render,
        ),
      ),
    );
  }
}

class ViewWrapCustomReorder extends ConsumerWidget {
  final Pos parentPos;
  final int parentMaxSize;
  final bool isInner;
  final bool isReorderAble;
  final Widget Function(int)? builder;

  const ViewWrapCustomReorder(this.parentPos,
      {required this.isReorderAble,
      this.builder,
      this.parentMaxSize = 100,
      this.isInner = true,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var node = ref.watch(choiceStatusProvider(parentPos));
    var children = node.getChildrenList();
    var presetMaxChildrenPerRow = parentMaxSize;
    var align = ChoiceLineAlignment.left;
    var height = isReorderAble ? defaultHeight : 0.0;
    if (!isInner) {
      var preset = ref.watch(lineDesignPresetProvider(pos: parentPos));
      presetMaxChildrenPerRow =
          preset.maxChildrenPerRow ?? presetMaxChildrenPerRow;
      align = preset.alignment ?? align;
    }
    var maxChildrenPerRow = min(parentMaxSize, ref.watch(maximumSizeProvider));
    maxChildrenPerRow = min(maxChildrenPerRow, presetMaxChildrenPerRow);

    var (sizeDataList, _) = node.node.getSizeDataList(
        align: align,
        maxChildrenPerRow: maxChildrenPerRow,
        showAll: isReorderAble);
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    for (var y = 0; y < sizeDataList.length; y++) {
      var verticalList = sizeDataList[y];
      var elementList = List<Expanded>.empty(growable: true);
      for (var element in verticalList) {
        if (element.pos != null) {
          elementList.add(Expanded(
            flex: element.width,
            child: isReorderAble
                ? NodeDraggable(element.pos!)
                : builder!(element.pos!.last),
          ));
        } else {
          elementList.add(Expanded(
              flex: element.width,
              child: SizedBox(
                height: height,
              )));
        }
      }
      if (isReorderAble) {
        var startPos = parentPos.addLast(0);
        if (y != 0) {
          var iterator = sizeDataList[y - 1].iterator;
          Pos? pointer;
          while (iterator.moveNext() && pointer == null) {
            pointer = iterator.current.pos;
          }
          startPos = pointer ?? parentPos.addLast(0);
        }
        outputWidget.add(DropRegionRow(
          startPos: startPos,
          widgets: elementList,
          sizeData: verticalList,
          maxChildrenPerRow: maxChildrenPerRow,
        ));
      } else {
        outputWidget.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: elementList,
            ),
          ),
        );
      }
      // outputWidgetList.add(value)
    }
    if (isReorderAble) {
      outputWidget.add(
        Stack(
          children: [
            Center(
              child: Card(
                child: CircleButton(
                  onPressed: () {
                    ref
                        .read(choiceStatusProvider(parentPos).notifier)
                        .addChoice(ChoiceNode.empty()..width = 3,
                            index: children.length);
                  },
                  tooltip: 'create_tooltip_node'.i18n,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (outputWidget.isEmpty) {
      outputWidget.add(const SizedBox.square(dimension: defaultHeight));
    }

    if (isInner) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: outputWidget,
      );
    }
    var preset = ref.watch(lineDesignPresetProvider(pos: parentPos));
    return DecoratedSliver(
      decoration: preset.backgroundColorOption!.colorType == ColorType.gradient
          ? BoxDecoration(
              gradient: preset.backgroundColorOption!.getGradient(),
            )
          : BoxDecoration(
              color: Color(preset.backgroundColorOption!.color),
            ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      ref.watch(platformDesignSettingProvider).marginVertical),
              child: outputWidget[index],
            );
          },
          childCount: outputWidget.length,
        ),
      ),
    );
  }
}

/*
* 요구사항
* 1. 선택지를 가로로 나열할 때, 선택지의 크기가 maxSize를 넘어가면 다음 줄로 넘어가야 한다.
* 2. 선택지를 리스트에서 전혀 다른 리스트로도 옮길 수 있어야 한다
* 3. sliver을 사용해서 최적화를 해야 한다.
* */
