import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
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
        feedback: Opacity(
          opacity: 0.5,
          child: SizedBox(
              width: controller.maxWidth /
                  (defaultMaxSize + 3) *
                  (widget.node!.width == 0
                      ? defaultMaxSize
                      : widget.node!.width),
              child: widget),
        ),
        onDragStarted: () {
          controller.dragStart(pos);
        },
        child: Opacity(
          child: widget,
          opacity: listEquals(controller.drag, pos) ? 0.2 : 1.0,
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
        feedback: Opacity(
          opacity: 0.5,
          child: SizedBox(
              width: controller.maxWidth /
                  (defaultMaxSize + 3) *
                  (widget.node!.width == 0
                      ? defaultMaxSize
                      : widget.node!.width),
              child: widget),
        ),
        onDragStarted: () {
          controller.dragStart(pos);
        },
        child: Opacity(
          child: widget,
          opacity: listEquals(controller.drag, pos) ? 0.2 : 1.0,
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
  final bool isHorizontal;

  const NodeDragTarget(this.x, this.y, {this.isHorizontal = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: DragTarget<List<int>>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          return ColoredBox(
            color: baseColor,
            child: isHorizontal ? const SizedBox(
              height: 100,
            ) : null,
          );
        },
        onAccept: (List<int> drag) {
          if (drag[drag.length - 1] == nonPositioned) {
            controller.changeData(drag, [y, x]);
          } else if (y == drag[0] && (x - 1) >= drag[1]) {
            controller.changeData(drag, [y, x - 1]);
          } else {
            controller.changeData(drag, [y, x]);
          }
        },
      ),
      visible: controller.drag != null,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
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

    if (controller.isVisibleOnlyEdit()) {
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
    Get.put(VMDraggableNestedMap());
    if (isEditable) {
      return GetBuilder<VMDraggableNestedMap>(
        builder: (_) => LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
            controller: _.scroller,
            child: RepaintBoundary(
              key: _.captureKey,
              child: Container(
                decoration: BoxDecoration(color: _.backgroundColor),
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
        builder: (_) {
          var inner = _.widgetList();
          return Container(
            decoration: BoxDecoration(color: _.backgroundColor),
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
