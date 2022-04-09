import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../viewModel/vm_draggable_nested_map.dart';

class NodeDraggable extends GetView<VMDraggableNestedMap> {
  final int x;
  final int y;
  final BoxConstraints constrains;
  const NodeDraggable(this.x, this.y, this.constrains, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widget = ViewChoiceNode(x, y);
    var pos = widget.node!.pos();
    if (ConstList.isSmallDisplay(context)) {
      return LongPressDraggable<List<int>>(
        onDragUpdate: (details) =>
            controller.dragUpdate(constrains, details, context),
        data: pos,
        feedback: Transform.scale(
          scale: 0.9,
          child: Opacity(opacity: 0.6, child: widget),
        ),
        onDragStarted: () {
          controller.dragStart(pos);
        },
        child: Visibility(
          child: widget,
          visible: !listEquals(controller.drag, pos),
        ),
        onDragEnd: (DraggableDetails data) {
          controller.dragEnd();
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          controller.dragEnd();
        },
      );
    } else {
      return Draggable<List<int>>(
        onDragUpdate: (details) =>
            controller.dragUpdate(constrains, details, context),
        data: pos,
        feedback: Transform.scale(
          scale: 0.9,
          child: Opacity(opacity: 0.6, child: widget),
        ),
        onDragStarted: () {
          controller.dragStart(pos);
        },
        child: Visibility(
          child: widget,
          visible: !listEquals(controller.drag, pos),
        ),
        onDragEnd: (DraggableDetails data) {
          controller.dragEnd();
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          controller.dragEnd();
        },
      );
    }
  }
}

class NodeDragTarget extends GetView<VMDraggableNestedMap> {
  final int x;
  final int y;
  final Color baseColor = Colors.black26;

  const NodeDragTarget(this.x, this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nodeBefore = VMChoiceNode.getNode([y, x - 1]);
    var node = VMChoiceNode.getNode([y, x]);

    bool longType1 = (node != null && node.width == 0) ||
        (nodeBefore != null && node == null && nodeBefore.width == 0);
    bool longType2 = y == getPlatform().lineSettings.length;
    bool realLong = longType1 || longType2;

    return Visibility(
      child: DragTarget<List<int>>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          if (longType1) {
            return Container(
              color: baseColor,
              width: double.infinity,
              height: nodeBaseHeight * 2,
            );
          }
          if (longType2) {
            return Container(
              color: baseColor,
              width: double.infinity,
              height: nodeBaseHeight * 10,
            );
          }
          return Container(
            color: baseColor,
            width: nodeBaseWidth / 6 * controller.getScale(),
            height: nodeBaseHeight * 10,
          );
        },
        onAccept: (List<int> drag) {
          if (drag[drag.length - 1] == nonPositioned) {
            controller.changeData(drag, [y, x]);
          } else {
            if(y == drag[0] && (x - 1) >= (drag[1] * 2)){
              controller.changeData(drag, [y, x - 1]);
            }else{
              controller.changeData(drag, [y, x]);
            }
          }
        },
      ),
      visible: controller.isVisibleDragTarget(x, y),
      maintainSize: realLong && VMDraggableNestedMap.isVisibleOnlyEdit(),
      maintainAnimation: realLong && VMDraggableNestedMap.isVisibleOnlyEdit(),
      maintainState: realLong && VMDraggableNestedMap.isVisibleOnlyEdit(),
    );
  }
}

class NodeDividerDialog extends StatelessWidget {
  final int y;
  const NodeDividerDialog(this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMDraggableNestedMap>(
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('선택 가능'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  _.addMaxSelect(y, -1);
                },
              ),
              Text(_.getMaxSelect(y)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  _.addMaxSelect(y, 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class NodeDivider extends GetView<VMDraggableNestedMap> {
  final int y;

  const NodeDivider(this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maxSelectText = Visibility(
      child: TextOutline(
          '최대 ${controller.getMaxSelect(y)}개만큼 선택 가능', 18.0, titleFont,
          strokeWidth: 5.0),
      visible: controller.getMaxSelect(y) != '무한',
    );

    var divider = Divider(
      thickness: 4,
      color: getPlatform().colorBackground.computeLuminance() > 0.5
          ? Colors.black45
          : Colors.white30,
    );

    if (VMDraggableNestedMap.isVisibleOnlyEdit()) {
      Future dialog() => Get.defaultDialog(
            title: '최대 선택지 개수 설정',
            content: NodeDividerDialog(y),
          );
      return Stack(
        children: [
          divider,
          maxSelectText,
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (result) {
                if (result == 0) {
                  dialog();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('최대 선택 설정'),
                  ),
                ];
              },
            ),
          ),
        ],
        alignment: Alignment.center,
      );
    } else {
      return Stack(
        children: [
          divider,
          maxSelectText,
        ],
        alignment: Alignment.center,
      );
    }
  }
}

class NestedMap extends StatelessWidget {
  const NestedMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEditable()) {
      return GetBuilder<VMDraggableNestedMap>(
        init: VMDraggableNestedMap(),
        builder: (_) => LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
            controller: _.scroller,
            child: RepaintBoundary(
              key: _.captureKey,
              child: Container(
                decoration: BoxDecoration(color: _.getBackgroundColor()),
                child: Column(
                  children: _.widgetList(constrains: constrains),
                ),
              ),
            ),
          );
        }),
      );
    } else {
      return GetBuilder<VMDraggableNestedMap>(
        init: VMDraggableNestedMap(),
        builder: (_) {
          var inner = _.widgetList();
          return Container(
            decoration: BoxDecoration(color: _.getBackgroundColor()),
            child: ListView.builder(
              controller: _.scroller,
              itemCount: _.getLength(),
              itemBuilder: (BuildContext context, int index) {
                return inner[index];
              },
              cacheExtent: 200,
            ),
          );
        },
      );
    }
  }
}
