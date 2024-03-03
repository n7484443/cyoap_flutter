import 'dart:math';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/util/view_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/choice/vm_choice_line.dart';
import '../../viewModel/vm_design_setting.dart';
import '../choice/view_choice_node.dart';
import '../view_draggable_nested_map.dart';

const double defaultHeight = 60.0;

class ViewWrapCustomReorder extends ConsumerWidget {
  final Pos parentPos;
  final int maxSize;
  final bool isInner;

  ViewWrapCustomReorder(this.parentPos,
      {this.maxSize = defaultMaxSize, this.isInner = true, super.key}) {
    if (ConstList.isMobile()) {
      mul = const (7, 4);
    } else {
      mul = const (5, 2);
    }
  }

  late final (int, int) mul;

  void addBuildDraggable(List<Widget> widget, int pos,
      {bool horizontal = false}) {
    if (horizontal) {
      widget.add(SizedBox(
          height: nodeBaseHeight / 6,
          child: NodeDragTarget(parentPos.addLast(pos))));
    } else {
      widget.add(Expanded(
          flex: mul.$2, child: NodeDragTarget(parentPos.addLast(pos))));
    }
  }

  int calculateFlex(int size) {
    return size * mul.$1 + (size - 1) * mul.$2;
  }

  int calculateFlexReverse(int size) {
    return size * mul.$2 + size * mul.$1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    var children = ref.watch(choiceStatusProvider(parentPos)).getChildrenList();
    if (children.isEmpty && isInner) {
      return SizedBox(
          height: nodeBaseHeight / 6,
          child: NodeDragTarget(parentPos.addLast(0)));
    }
    int stack = 0;
    List<Widget> subWidget = List<Widget>.empty(growable: true);
    for (int i = 0; i < children.length; i++) {
      var child = children[i];
      int size = child.width == 0 ? maxSize : min(child.width, maxSize);
      if (stack == 0 && i == 0) {
        addBuildDraggable(outputWidget, i, horizontal: true);
      }
      if (stack + size > maxSize) {
        if (stack < maxSize) {
          subWidget.add(
            Expanded(
              flex: calculateFlexReverse(maxSize - stack),
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
      }

      if (size == maxSize) {
        if (i != 0) {
          var before = (children[i - 1] as ChoiceNode).width;
          if (before != 0 && before != maxSize) {
            addBuildDraggable(outputWidget, i, horizontal: true);
          }
        }
        outputWidget.add(NodeDraggable(child.pos));
        subWidget = List.empty(growable: true);
        addBuildDraggable(outputWidget, i + 1, horizontal: true);
        continue;
      }

      subWidget.add(
          Expanded(flex: calculateFlex(size), child: NodeDraggable(child.pos)));
      addBuildDraggable(subWidget, i + 1);
      stack += size;
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
    bool check = false;
    if (0 < stack && stack < maxSize) {
      subWidget.add(
        Expanded(
          flex: calculateFlexReverse(maxSize - stack),
          child: Stack(
            children: [
              Center(
                child: addButton,
              ),
            ],
          ),
        ),
      );
    } else {
      check = true;
    }
    if (subWidget.isEmpty) {
      addBuildDraggable(outputWidget, 0, horizontal: true);
    }
    outputWidget.add(
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: subWidget,
        ),
      ),
    );
    if (check) {
      outputWidget.add(
        Stack(
          children: [
            Center(
              child: addButton,
            ),
          ],
        ),
      );
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
      return const SizedBox(
          height: nodeBaseHeight / 6);
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
