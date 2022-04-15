import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/generable_parser.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../model/abstract_platform.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_variable_table.dart';

class ViewChoiceNode extends GetView<VMDraggableNestedMap> {
  final ChoiceNodeBase? node;

  ViewChoiceNode(int posX, int posY, {Key? key})
      : node = posX == nonPositioned && posY == nonPositioned
            ? null
            : getPlatform.getChoiceNode([posY, posX])!,
        super(key: key);

  const ViewChoiceNode.fromNode(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (node == null) {
      return Card(
        child: SizedBox(
          width: controller.maxWidth / defaultMaxSize * 3 * controller.scale,
          height: nodeBaseHeight * controller.scale,
        ),
      );
    }
    var nodeController = Get.put(VMChoiceNode.fromNode(node!), tag: node!.tag);

    var editor = Obx(() {
      return IgnorePointer(
        child: QuillEditor(
          controller: nodeController.quillController,
          focusNode: FocusNode(),
          readOnly: true,
          autoFocus: false,
          expands: false,
          padding: const EdgeInsets.only(top: 4),
          scrollController: ScrollController(),
          scrollable: false,
          customStyles: ConstList.getDefaultThemeData(context, controller.scale,
              fontStyle: ConstList.getFont(controller.mainFont.value)),
        ),
      );
    });

    var mainBox = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            if (nodeController.imageString.value.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 3.5,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: PlatformSystem.getImage(
                        nodeController.imageString.value),
                  ),
                ),
              ),
            if (nodeController.titleString.value.isNotEmpty)
              TextOutline(
                nodeController.titleString.value,
                20 * controller.scale,
                ConstList.getFont(controller.titleFont.value),
              ),
          ],
        ),
        editor,
        if (controller.isVisibleOnlyEdit()) ChoiceNodeSubDragTarget(node!),
        if (node!.children.isNotEmpty)
          ViewWrapCustom(
            node!.children,
            (child) => ViewChoiceNode.fromNode(child),
            maxSize: node!.width,
          )
      ],
    );

    var baseColor = node!.isCard ? Colors.white : baseNodeColor;
    var mainNode = Ink(
      color: baseColor,
      child: InkWell(
        onDoubleTap: isEditable
            ? () {
                controller.setEdit(node!);
                Get.toNamed('/viewEditor', id: 1);
              }
            : null,
        onTap: !isEditable
            ? () async {
                nodeController.select();
                if (nodeController.isRandom.value) {
                  if (nodeController.isSelect()) {
                    nodeController.startRandom();
                    await showDialog(
                      context: context,
                      builder: (builder) => RandomDialog(node),
                      barrierDismissible: false,
                    );
                  } else {
                    node!.random = -1;
                  }
                }
                VMChoiceNode.updateStatusAll();
              }
            : null,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            mainBox,
            if (controller.isVisibleOnlyEdit()) ...[
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (result) {
                    if (result == 0) {
                      showDialog(
                        context: context,
                        builder: (builder) => SizeDialog(node),
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('크기 수정'),
                      ),
                    ];
                  },
                ),
              )
            ] else if (getPlatformFileSystem
                    .hasSource(nodeController.imageString.value) &&
                Get.find<VMVariableTable>().isVisibleSource) ...[
              Positioned(
                bottom: 0,
                left: 0,
                child: TextButton(
                  child: const Text(
                    '출처',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    var url = getPlatformFileSystem
                        .getSource(nodeController.imageString.value);
                    if (url != null && url.isNotEmpty) {
                      launch(url);
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return Obx(
      () {
        var isSelectedCheck = nodeController.status.value.isSelected() &&
            nodeController.node.isSelectable;
        return Opacity(
          opacity: nodeController.opacity,
          child: Card(
            shape: isSelectedCheck
                ? nodeController.isCardMode.value
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 6,
                        ),
                      )
                    : const Border.fromBorderSide(
                        BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 6,
                        ),
                      )
                : null,
            color: baseColor,
            clipBehavior: Clip.antiAlias,
            elevation:
                nodeController.isCardMode.value ? ConstList.elevation : 0,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: isEditable
                  ? mainNode
                  : IgnorePointer(
                      ignoring: !nodeController.isIgnorePointer(),
                      child: mainNode,
                    ),
            ),
          ),
        );
      },
    );
  }
}

class SizeDialog extends StatelessWidget {
  final ChoiceNodeBase? node;

  const SizeDialog(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = VMChoiceNode.getVMChoiceNodeFromNode(node!)!;
    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      title: const Text('크기 수정'),
      content: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('길이'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    controller.sizeChange(-1);
                  },
                ),
                Text(
                    '${controller.size.value == 0 ? 'max' : controller.size.value}'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    controller.sizeChange(1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RandomDialog extends StatelessWidget {
  final ChoiceNodeBase? node;

  const RandomDialog(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = VMChoiceNode.getVMChoiceNodeFromNode(node!)!;
    return Obx(
      () => AlertDialog(
          scrollable: true,
          title: const Text('랜덤'),
          content: AnimatedFlipCounter(
              value: controller.randomValue.value,
              duration: const Duration(milliseconds: 500),
              textStyle: const TextStyle(
                fontSize: 40,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            Opacity(
              opacity: controller.randomProcess.value ? 0 : 1,
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('확인'),
              ),
            )
          ]),
    );
  }
}

class ChoiceNodeSubDragTarget extends GetView<VMDraggableNestedMap> {
  final ChoiceNodeBase node;

  const ChoiceNodeSubDragTarget(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: DragTarget(
        builder: (BuildContext context, List<Object?> candidateData,
                List<dynamic> rejectedData) =>
            Container(
          color: Colors.blueAccent.withOpacity(0.3),
          height: 20,
        ),
        onAccept: (List<int> data) {
          if (data[data.length - 1] == nonPositioned) {
            node.addChildren(VMDraggableNestedMap.createNodeForTemp());
            controller.updateVMChoiceNode(node.pos());
          } else {
            var childNode = getPlatform.getChoiceNode(data)!;
            var parentLastPos = childNode.getParentLast()!.pos();
            childNode.parent!.removeChildren(childNode);
            node.addChildren(childNode);
            controller.updateVMChoiceNode(parentLastPos);
            controller.update();
          }
          getPlatform.checkDataCollect();
        },
      ),
      visible: controller.drag != null && controller.drag != node.pos(),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
    );
  }
}
