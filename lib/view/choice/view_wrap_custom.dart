import 'dart:math';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/util/view_circle_button.dart';
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
  final List<(int, Pos)> sizeData;
  final int maxSize;
  final bool isEmpty;

  const DropRegionRow(
      {super.key,
      required this.widgets,
      required this.sizeData,
      required this.maxSize,
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
        var spaceWidth = width / widget.maxSize;
        var x = mousePos.local.dx / spaceWidth;
        var minLength = 0.25;
        var before = 0;
        if (widget.isEmpty) {
          var (_, pos) = widget.sizeData.first;
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
          var (i, pos) = widget.sizeData[index];
          if (x < before) {
            setState(() {
              this.index = -1;
            });
            return DropOperation.none;
          }
          if (x > before + i) {
            before += i;
            continue;
          }
          if (drag.isParent(pos)) {
            setState(() {
              this.index = -1;
            });
            return DropOperation.none;
          }
          var left = x - before;
          var right = before + i - x;
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
        if (isEntered && index >= 0) {
          index = index ~/ 2;
          var (_, pos) = widget.sizeData[index];
          if (index.isEven) {
            add(data, pos, ref);
          } else {
            var nextPos = List<int>.from(pos.data, growable: true);
            nextPos.last += 1;
            add(data, Pos(data: nextPos), ref);
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
  final int maxSize;
  final bool isInner;

  const ViewWrapCustomReorder(this.parentPos,
      {this.maxSize = defaultMaxSize, this.isInner = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    var node = ref.watch(choiceStatusProvider(parentPos));
    var children = node.getChildrenList();
    int stack = 0;
    List<Expanded> subWidget = List<Expanded>.empty(growable: true);
    List<(int, Pos)> sizeData = List<(int, Pos)>.empty(growable: true);
    for (var child in children) {
      int size = child.width == 0 ? maxSize : min(child.width, maxSize);
      var node = Expanded(
        flex: size,
        child: NodeDraggable(child.pos),
      );

      if (stack + size < maxSize) {
        subWidget.add(node);
        sizeData.add((size, child.pos));
        stack += size;
      } else if (stack + size == maxSize) {
        subWidget.add(node);
        sizeData.add((size, child.pos));
        outputWidget.add(DropRegionRow(
            widgets: subWidget, maxSize: maxSize, sizeData: sizeData));
        subWidget = List<Expanded>.empty(growable: true);
        sizeData = List<(int, Pos)>.empty(growable: true);
        stack = 0;
      } else {
        subWidget.add(Expanded(
          flex: maxSize - stack,
          child: const SizedBox(
            height: defaultHeight,
          ),
        ));
        sizeData.add((maxSize - stack, child.pos));
        outputWidget.add(DropRegionRow(
            widgets: subWidget, maxSize: maxSize, sizeData: sizeData));
        subWidget = List<Expanded>.empty(growable: true);
        sizeData = List<(int, Pos)>.empty(growable: true);
        subWidget.add(node);
        sizeData.add((size, child.pos));
        stack = size;
      }
    }
    if (subWidget.isNotEmpty || children.isEmpty) {
      if (stack != maxSize) {
        subWidget.add(Expanded(
          flex: maxSize - stack,
          child: const SizedBox(
            height: defaultHeight,
          ),
        ));
        sizeData.add((maxSize - stack, parentPos.addLast(children.length)));
      }
      outputWidget.add(DropRegionRow(
          widgets: subWidget,
          maxSize: maxSize,
          sizeData: sizeData,
          isEmpty: children.isEmpty));
    }
    Widget addButton = Card(
      child: CircleButton(
        onPressed: () {
          ref
              .read(choiceStatusProvider(parentPos).notifier)
              .addChoice(ChoiceNode.empty()..width = 3, index: children.length);
        },
        tooltip: 'create_tooltip_node'.i18n,
        child: const Icon(Icons.add),
      ),
    );
    outputWidget.add(
      Stack(
        children: [
          Center(
            child: addButton,
          ),
        ],
      ),
    );

    if (isInner) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: outputWidget,
      );
    }
    var preset = ref.watch(lineDesignPresetProvider(pos: parentPos));
    return DecoratedSliver(
      decoration: preset.backgroundColorOption.colorType == ColorType.gradient
          ? BoxDecoration(
              gradient: preset.backgroundColorOption.getGradient(),
            )
          : BoxDecoration(
              color: Color(preset.backgroundColorOption.color),
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

class ViewWrapCustom extends ConsumerWidget {
  final Pos parentPos;
  final Widget Function(int) builder;
  final int maxSize;
  final bool isInner;

  const ViewWrapCustom(this.parentPos, this.builder,
      {this.isInner = true, this.maxSize = defaultMaxSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    var children = ref.watch(choiceStatusProvider(parentPos)).getChildrenList();
    if (children.isEmpty && isInner) {
      return const SizedBox(height: nodeBaseHeight / 6);
    }
    int stack = 0;
    List<Widget> subWidget = List<Widget>.empty(growable: true);
    for (int i = 0; i < children.length; i++) {
      var child = children[i] as ChoiceNode;
      if (child.isHide()) {
        continue;
      }
      int size = child.width == 0 ? maxSize : min(child.width, maxSize);

      if (stack + size > maxSize) {
        if (maxSize > stack) {
          subWidget.add(
            Expanded(
              flex: maxSize - stack,
              child: const SizedBox.shrink(),
            ),
          );
        }
        outputWidget.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: subWidget,
            ),
          ),
        );
        subWidget = List.empty(growable: true);
        stack = 0;
        i -= 1;
        continue;
      } else if (size == maxSize) {
        outputWidget.add(SizedBox(width: double.infinity, child: builder(i)));
        subWidget = List.empty(growable: true);
      } else {
        subWidget.add(Expanded(flex: size, child: builder(i)));
        stack += size;
      }
    }
    if (0 < stack && stack < maxSize) {
      subWidget
          .add(Expanded(flex: maxSize - stack, child: const SizedBox.shrink()));
    }
    if (subWidget.isNotEmpty) {
      if (subWidget.length == 1) {
        outputWidget.add(subWidget.first);
      } else {
        outputWidget.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: subWidget,
            ),
          ),
        );
      }
    } else if (!isInner) {
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
      decoration: preset.backgroundColorOption.colorType == ColorType.gradient
          ? BoxDecoration(
              gradient: preset.backgroundColorOption.getGradient(),
            )
          : BoxDecoration(
              color: Color(preset.backgroundColorOption.color),
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
