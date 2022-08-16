import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../model/choiceNode/choice_node.dart';
import '../../model/choiceNode/generable_parser.dart';
import '../../model/choiceNode/pos.dart';
import '../view_choice_node.dart';

const int defaultMaxSize = 12;

class ViewWrapCustomReorderable extends ConsumerWidget {
  final Pos parentPos;
  final Widget Function(int) builderDraggable;
  final int maxSize;
  final bool setCenter;

  ViewWrapCustomReorderable(this.parentPos, this.builderDraggable,
      {this.maxSize = defaultMaxSize, this.setCenter = false, Key? key})
      : super(key: key) {
    if (ConstList.isMobile()) {
      mul = const Tuple2(7, 4);
    } else {
      mul = const Tuple2(5, 2);
    }
  }

  late final Tuple2<int, int> mul;

  void addBuildDraggable(List<Widget> widget, int pos,
      {bool horizontal = false}) {
    if (horizontal) {
      widget.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            SizedBox(height: nodeBaseHeight / 6, child: builderDraggable(pos)),
      ));
    } else {
      widget.add(Expanded(flex: mul.item2, child: builderDraggable(pos)));
    }
  }

  int calculateFlex(int size) {
    return size * mul.item1 + (size - 1) * mul.item2;
  }

  int calculateFlexReverse(int size) {
    return size * mul.item2 + size * mul.item1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    var children = ref.watch(childrenChangeProvider(parentPos));
    if (children.isNotEmpty) {
      int stack = 0;
      List<Widget> subWidget = List<Widget>.empty(growable: true);
      for (int i = 0; i < children.length; i++) {
        var child = children[i] as ChoiceNode;
        int size = child.width == 0 ? maxSize : child.width;
        if (stack == 0 && i == 0) {
          addBuildDraggable(outputWidget, i, horizontal: true);
        }
        if (stack + size > maxSize) {
          if (maxSize > stack) {
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
        } else if (size == maxSize) {
          if (i != 0) {
            var before = (children[i - 1] as ChoiceNode).width;
            if (before != 0 && before != maxSize) {
              addBuildDraggable(outputWidget, i, horizontal: true);
            }
          }
          outputWidget.add(NodeDraggable(child.pos));
          subWidget = List.empty(growable: true);
          addBuildDraggable(outputWidget, i + 1, horizontal: true);
        } else {
          subWidget.add(Expanded(
              flex: calculateFlex(size), child: NodeDraggable(child.pos)));
          addBuildDraggable(subWidget, i + 1);
          stack += size;
        }
      }
      if (0 < stack && stack < maxSize) {
        subWidget.add(Expanded(
            flex: calculateFlexReverse(maxSize - stack),
            child: const SizedBox.shrink()));
      }
      if (subWidget.isNotEmpty) {
        outputWidget.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: subWidget,
            ),
          ),
        );
      }
    } else {
      addBuildDraggable(outputWidget, children.length, horizontal: true);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: outputWidget,
    );
  }
}

class ViewWrapCustom extends ConsumerWidget {
  final Pos parentPos;
  final Widget Function(ChoiceNode) builder;
  final int maxSize;
  final bool isInner;

  const ViewWrapCustom(this.parentPos, this.builder,
      {this.isInner = true, this.maxSize = defaultMaxSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    var children = ref.watch(childrenProvider(parentPos));
    if (children.isNotEmpty) {
      int stack = 0;
      List<Widget> subWidget = List<Widget>.empty(growable: true);
      for (int i = 0; i < children.length; i++) {
        var child = children[i] as ChoiceNode;
        if (!child.isOccupySpace && child.status.isHide()) {
          continue;
        }
        int size = child.width == 0 ? maxSize : child.width;

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
          outputWidget
              .add(SizedBox(width: double.infinity, child: builder(child)));
          subWidget = List.empty(growable: true);
        } else {
          subWidget.add(Expanded(flex: size, child: builder(child)));
          stack += size;
        }
      }
      if (0 < stack && stack < maxSize) {
        subWidget.add(
            Expanded(flex: maxSize - stack, child: const SizedBox.shrink()));
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
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: outputWidget,
    );
  }
}
