import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';

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
  }

  final int mul = 4;

  void setEmptyFlexible(List<List<Widget>> widget, int innerPos) {
    if (innerPos < maxSize) {
      var leftOver = (maxSize - innerPos);
      if (setCenter) {
        var d = leftOver;
        widget.last
            .insert(0, Expanded(flex: d, child: const SizedBox.shrink()));
        widget.last.add(Expanded(flex: d, child: const SizedBox.shrink()));
      } else {
        widget.last.add(
          Expanded(
            flex: leftOver * mul,
            child: const SizedBox(
              width: double.infinity,
              height: 0,
            ),
          ),
        );
      }
    }
  }

  void addBuildDraggable(List<List<Widget>> widget, int pos,
      {bool horizontal = false}) {
    if (builderDraggable != null) {
      widget.last.add(Expanded(
          flex: 1,
          child: horizontal
              ? SizedBox(
                  height: nodeBaseHeight / 6,
                  child: builderDraggable!(pos),
                )
              : builderDraggable!(pos)));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> widget =
        List.filled(1, List<Widget>.empty(growable: true), growable: true);

    if (children.isEmpty) {
      addBuildDraggable(widget, children.length, horizontal: true);
    } else {
      int inner = 0;
      int size = 0;
      for (int i = 0; i < children.length; i++) {
        var child = children[i] as ChoiceNode;
        size = child.width == 0 ? maxSize : child.width;
        if (size == maxSize) {
          if (inner != 0) {
            addBuildDraggable(widget, i);
            setEmptyFlexible(widget, inner);
          }
          widget.add(List<Widget>.empty(growable: true));
          addBuildDraggable(widget, i, horizontal: true);
          widget.add(List<Widget>.empty(growable: true));
          widget.last.add(Expanded(flex: size * mul, child: builder(child)));
          widget.add(List<Widget>.empty(growable: true));
          inner = 0;
        } else {
          addBuildDraggable(widget, i);
          if (inner + size > maxSize) {
            setEmptyFlexible(widget, inner);
            inner = size;
            widget.add(List<Widget>.empty(growable: true));
          } else {
            inner += size;
          }
          widget.last.add(Expanded(flex: size * mul, child: builder(child)));
        }
      }
      if (size == maxSize) {
        widget.add(List<Widget>.empty(growable: true));
        addBuildDraggable(widget, children.length, horizontal: true);
      } else {
        addBuildDraggable(widget, children.length);
        setEmptyFlexible(widget, inner);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.where((value) => value.isNotEmpty).map(
        (e) {
          if (e.length == 1) {
            return Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Row(
                children: e,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: e,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class ViewWrapCustom extends StatelessWidget {
  final List<GenerableParserAndPosition> children = List.empty(growable: true);
  final Widget Function(ChoiceNode) builder;
  final int maxSize;
  final bool setCenter;

  ViewWrapCustom(List<GenerableParserAndPosition> children, this.builder,
      {this.maxSize = defaultMaxSize, this.setCenter = false, Key? key})
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
          subWidget.add(
            Expanded(
              flex: maxSize - stack,
              child: const SizedBox.shrink(),
            ),
          );
          outputWidget.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: subWidget,
              ),
            ),
          );
          if (size == maxSize) {
            outputWidget.add(builder(child));
            subWidget = List.empty(growable: true);
            stack = 0;
          } else {
            subWidget = List.from([Expanded(flex: size, child: builder(child))],
                growable: true);
            stack = size;
          }
        } else {
          subWidget.add(Expanded(flex: size, child: builder(child)));
          if (stack + size == maxSize) {
            outputWidget.add(IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: subWidget,
              ),
            ));
            subWidget = List.empty(growable: true);
            stack = 0;
          } else {
            stack += size;
          }
        }
      }
      if (0 < stack && stack < maxSize) {
        subWidget.add(
            Expanded(flex: maxSize - stack, child: const SizedBox.shrink()));
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
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: outputWidget.map(
        (e) {
          return Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: e,
          );
        },
      ).toList(),
    );
  }
}
