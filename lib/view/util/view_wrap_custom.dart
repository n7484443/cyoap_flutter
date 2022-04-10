import 'package:flutter/material.dart';

import '../../model/choiceNode/choice_node.dart';
import '../../model/choiceNode/generable_parser.dart';

class ViewWrapCustom extends StatelessWidget {
  final List<GenerableParserAndPosition> children = List.empty(growable: true);
  final Widget Function(ChoiceNodeBase) builder;
  final int maxSize;
  final bool setSizeSame;

  ViewWrapCustom(List<GenerableParserAndPosition> children, this.builder,
      {this.setSizeSame = true, this.maxSize = 12, Key? key})
      : super(key: key) {
    this.children.addAll(children);
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> widget =
        List.filled(1, List<Widget>.empty(growable: true), growable: true);

    int inner = 0;
    for (int i = 0; i < children.length; i++) {
      var child = children[i] as ChoiceNodeBase;
      var size = child.width == 0 ? maxSize : child.width;
      if (inner + size > maxSize) {
        if (maxSize != inner) {
          widget.last.add(
              Flexible(flex: maxSize - inner, child: const SizedBox.shrink()));
        }
        widget.add(List<Widget>.empty(growable: true));
        inner = size;
      } else {
        inner += size;
      }
      Widget innerWidget = builder(child);
      widget.last.add(Flexible(flex: size, child: innerWidget));
    }
    if (inner < maxSize) {
      widget.last
          .add(Flexible(flex: maxSize - inner, child: const SizedBox.shrink()));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.map(
        (e) {
          if (e.length == 1) {
            return e[0];
          }
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: e,
            ),
          );
        },
      ).toList(),
    );
  }
}
