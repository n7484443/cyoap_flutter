import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';

import '../../model/choiceNode/choice_node.dart';
import '../../model/choiceNode/generable_parser.dart';

const int defaultMaxSize = 12;

class ViewWrapCustom extends StatelessWidget {
  final List<GenerableParserAndPosition> children = List.empty(growable: true);
  final Widget Function(ChoiceNode) builder;
  final Widget Function(int)? builderDraggable;
  final int maxSize;
  final bool isAllVisible;
  final bool setCenter;

  ViewWrapCustom(List<GenerableParserAndPosition> children, this.builder,
      {this.isAllVisible = false,
      this.maxSize = defaultMaxSize,
      this.builderDraggable,
      this.setCenter = false,
      Key? key})
      : super(key: key) {
    this.children.addAll(children);
  }

  final int mul = 4;

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> widget =
        List.filled(1, List<Widget>.empty(growable: true), growable: true);

    void setEmptyFlexible(int innerPos) {
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

    void addBuildDraggable(int pos, {bool horizontal = false}) {
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

    if(children.isEmpty){
      addBuildDraggable(children.length, horizontal: true);
    }else{
      int inner = 0;
      int size = 0;
      for (int i = 0; i < children.length; i++) {
        var child = children[i] as ChoiceNode;
        if(!isAllVisible && !child.isOccupySpace && child.status.isHide()){
          continue;
        }
        size = child.width == 0 ? maxSize : child.width;
        if (size == maxSize) {
          if (inner != 0) {
            addBuildDraggable(i);
            setEmptyFlexible(inner);
          }
          widget.add(List<Widget>.empty(growable: true));
          addBuildDraggable(i, horizontal: true);
          widget.add(List<Widget>.empty(growable: true));
          widget.last.add(Expanded(flex: size * mul, child: builder(child)));
          widget.add(List<Widget>.empty(growable: true));
          inner = 0;
        } else {
          addBuildDraggable(i);
          if (inner + size > maxSize) {
            setEmptyFlexible(inner);
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
        addBuildDraggable(children.length, horizontal: true);
      } else {
        addBuildDraggable(children.length);
        setEmptyFlexible(inner);
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
