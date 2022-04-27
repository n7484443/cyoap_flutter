import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/abstract_platform.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_draggable_nested_map.dart';

class NodeDragTarget extends GetView<VMDraggableNestedMap> {
  final List<int> pos;
  final Color baseColor = Colors.black26;
  final bool isHorizontal;

  const NodeDragTarget(this.pos, {this.isHorizontal = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: DragTarget<List<int>>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          return Container(
            color: baseColor,
            height: isHorizontal ? 200 : null,
          );
        },
        onAccept: (List<int> drag) {
          if (drag[drag.length - 1] == nonPositioned) {
            controller.changeData(drag, pos);
          } else if (pos[0] == drag[0] && (pos[1] - 1) >= drag[1]) {
            controller.changeData(drag, [pos[0], pos[1] - 1]);
          } else {
            controller.changeData(drag, pos);
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
      color: getPlatform.colorBackground.computeLuminance() > 0.5
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
          _.constrain = constrains;
          return SingleChildScrollView(
            controller: _.scroller,
            child: RepaintBoundary(
              key: _.captureKey,
              child: Container(
                decoration: BoxDecoration(color: _.backgroundColor),
                child: Column(
                  children: _.widgetList(),
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
              cacheExtent: 400,
            ),
          );
        },
      );
    }
  }
}
