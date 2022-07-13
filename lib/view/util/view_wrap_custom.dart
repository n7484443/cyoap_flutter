import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:tuple/tuple.dart';

import '../../model/choiceNode/choice_node.dart';
import '../../model/choiceNode/generable_parser.dart';

const int defaultMaxSize = 12;

class ViewWrapCustomReorderable extends StatelessWidget {
  final List<GenerableParserAndPosition> children = List.empty(growable: true);
  final Widget Function(ChoiceNode) builder;
  final Widget Function(int)? builderDraggable;
  final int maxSize;
  final bool setCenter;

  ViewWrapCustomReorderable(
      List<GenerableParserAndPosition> children, this.builder,
      {this.maxSize = defaultMaxSize,
      this.builderDraggable,
      this.setCenter = false,
      Key? key})
      : super(key: key) {
    this.children.addAll(children);
    if (GetPlatform.isMobile) {
      mul = const Tuple2(7, 4);
    } else {
      mul = const Tuple2(5, 2);
    }
  }

  late final Tuple2<int, int> mul;

  void addBuildDraggable(List<Widget> widget, int pos,
      {bool horizontal = false}) {
    if (builderDraggable != null) {
      if (horizontal) {
        widget.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: nodeBaseHeight / 6, child: builderDraggable!(pos)),
        ));
      } else {
        widget.add(Expanded(flex: mul.item2, child: builderDraggable!(pos)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
    if (children.isNotEmpty) {
      int stack = 0;
      List<Widget> subWidget = List<Widget>.empty(growable: true);
      for (int i = 0; i < children.length; i++) {
        var child = children[i] as ChoiceNode;
        if (!child.isOccupySpace && child.status.isHide()) {
          continue;
        }
        int size = child.width == 0 ? maxSize : child.width;
        if (stack == 0 && i == 0) {
          addBuildDraggable(outputWidget, i, horizontal: true);
        }
        if (stack + size > maxSize) {
          if (maxSize > stack) {
            subWidget.add(
              Expanded(
                flex: (maxSize - stack) * mul.item1,
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
          outputWidget.add(builder(child));
          subWidget = List.empty(growable: true);
          addBuildDraggable(outputWidget, i + 1, horizontal: true);
        } else {
          subWidget
              .add(Expanded(flex: size * mul.item1, child: builder(child)));
          addBuildDraggable(subWidget, i + 1);
          stack += size;
        }
      }
      if (0 < stack && stack < maxSize) {
        subWidget.add(Expanded(
            flex: (maxSize - stack) * mul.item1,
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

class ViewWrapCustom extends StatelessWidget {
  final List<GenerableParserAndPosition> children = List.empty(growable: true);
  final Widget Function(ChoiceNode) builder;
  final int maxSize;
  final bool isInner;

  ViewWrapCustom(List<GenerableParserAndPosition> children, this.builder,
      {this.isInner = true, this.maxSize = defaultMaxSize, Key? key})
      : super(key: key) {
    this.children.addAll(children);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> outputWidget = List<Widget>.empty(growable: true);
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
          outputWidget.add(SizedBox(width: double.infinity, child: builder(child)));
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
