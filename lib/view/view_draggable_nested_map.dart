import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_text_outline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../util/tuple.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_platform.dart';

class NodeDraggable extends GetView<VMDraggableNestedMap> {
  final int x;
  final int y;
  final BoxConstraints constrains;
  const NodeDraggable(this.x, this.y, this.constrains, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widget = getChoiceWidget(getPlatform().getChoiceNode(x, y)!.isCard, x, y);
    var pos = Tuple(x, y);
    if (ConstList.isSmallDisplay(context)) {
      return LongPressDraggable<Tuple<int, int>>(
        onDragUpdate: (details) =>
            controller.dragUpdate(constrains, details, context),
        data: pos,
        feedback: Transform.scale(
          scale: 0.9,
          child: Opacity(
            opacity: 0.6,
            child: widget
          ),
        ),
        onDragStarted: () {
          controller.dragStart(pos);
        },
        child: Visibility(
          child: widget,
          visible: controller.drag != pos,
        ),
        onDragEnd: (DraggableDetails data) {
          controller.dragEnd();
        },
        onDraggableCanceled:
            (Velocity velocity, Offset offset) {
              controller.dragEnd();
        },
      );
    } else {
      return Draggable<Tuple<int, int>>(
        onDragUpdate: (details) =>
            controller.dragUpdate(constrains, details, context),
        data: pos,
        feedback: Transform.scale(
          scale: 0.9,
          child: Opacity(
              opacity: 0.6,
              child: widget
          ),
        ),
        onDragStarted: () {
          controller.dragStart(pos);
        },
        child: Visibility(
          child: widget,
          visible: controller.drag != pos,
        ),
        onDragEnd: (DraggableDetails data) {
          controller.dragEnd();
        },
        onDraggableCanceled:
            (Velocity velocity, Offset offset) {
              controller.dragEnd();
        },
      );
    }
  }
}


class NodeDraggableTarget extends GetView<VMDraggableNestedMap> {
  final int x;
  final int y;
  final Color baseColor = Colors.black26;

  const NodeDraggableTarget(this.x, this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nodeBefore = controller.getNode(x - 1, y);
    var node = controller.getNode(x, y);

    bool long = (node != null && node.width == 0) || (nodeBefore != null && node == null && nodeBefore.width == 0);
    bool long2 = y == getPlatform().choiceNodes.length;
    bool realLong = long || long2;

    return Visibility(
      child: DragTarget<Tuple<int, int>>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          if (long) {
            return Container(
              color: baseColor,
              width: double.infinity,
              height:
                  controller.nodeBaseHeight * 2 * controller.getScale().data2,
            );
          }
          if(long2){
            return Container(
              color: baseColor,
              width: double.infinity,
              height:
              controller.nodeBaseHeight * 10 * controller.getScale().data2,
            );
          }
          return Container(
            color: baseColor,
            width: controller.nodeBaseWidth / 6 * controller.getScale().data1,
            height:
                controller.nodeBaseHeight * 10 * controller.getScale().data2,
          );
        },
        onAccept: (Tuple<int, int> data) {
          if (controller.drag == Tuple(-10, -10)) {
            controller.changeData(data, Tuple(x, y));
          } else {
            if ((x - 2) > (controller.drag!.data1 * 2)) {
              controller.changeData(data, Tuple(x - 1, y));
            } else {
              controller.changeData(data, Tuple(x, y));
            }
          }
        },
      ),
      visible: controller.drag != null && controller.drag != Tuple(x - 1, y),
      maintainSize: realLong,
      maintainAnimation: realLong,
      maintainState: realLong,
    );
  }
}

class NodeDivider extends GetView<VMDraggableNestedMap> {
  final int y;

  const NodeDivider(this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future dialog() => Get.defaultDialog(
      title: '최대 선택지 개수 설정',
      content: GetBuilder<VMDraggableNestedMap>(
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
            Row(
              children: [
                const Text('탭 높이 설정'),
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
      ),
    );

    var maxSelectText = Visibility(
      child: TextOutline('최대 ${controller.getMaxSelect(y)}개만큼 선택 가능', 18.0,
          controller.getTitleFont(),
          strokeWidth: 5.0),
      visible: controller.getMaxSelect(y) != '무한',
    );

    if (controller.isEditable()) {
      return Stack(
        children: [
          Divider(
            thickness: 4,
            color: getPlatform().colorBackground.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
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
          Divider(
            thickness: 4,
            color: getPlatform().colorBackground.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          ),
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
    var controller = Get.put(VMDraggableNestedMap());
    if (controller.isEditable()) {
      return GetBuilder<VMDraggableNestedMap>(
        builder: (_) => LayoutBuilder(builder: (context, constrains) {
          return RepaintBoundary(
            key: _.captureKey,
            child: Container(
              decoration: BoxDecoration(color: _.getBackgroundColor()),
              child: ListView(
                controller: _.scroller,
                children: _.updateWidgetList(constrains: constrains),
              ),
            ),
          );
        }),
      );
    } else {
      return GetBuilder<VMDraggableNestedMap>(
        builder: (_) {
          var inner = _.updateWidgetList();
          return Container(
            decoration: BoxDecoration(color: _.getBackgroundColor()),
            child: ListView.builder(
              controller: _.scroller,
              itemCount: _.getLength(),
              itemBuilder: (BuildContext context, int index) {
                return inner[index];
              },
              cacheExtent: 100,
            ),
          );
        },
      );
    }
  }
}
