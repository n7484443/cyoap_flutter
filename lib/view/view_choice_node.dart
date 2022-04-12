import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/generable_parser.dart';
import 'package:cyoap_flutter/util/color_util.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../model/platform_system.dart';

class ViewChoiceNode extends StatelessWidget {
  final ChoiceNodeBase? node;

  ViewChoiceNode(int posX, int posY, {Key? key})
      : node = posX == nonPositioned && posY == nonPositioned
            ? null
            : getPlatform().getChoiceNode([posY, posX])!,
        super(key: key);

  const ViewChoiceNode.fromNode(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmDraggableNestedMap = Get.find<VMDraggableNestedMap>();
    var scale = vmDraggableNestedMap.getScale();
    if (node == null) {
      return Card(
        child: SizedBox(
          width: vmDraggableNestedMap.getMaxWidth() / defaultMaxSize * 3 * scale,
          height: nodeBaseHeight * scale,
        ),
      );
    }
    var controller = Get.put(VMChoiceNode.fromNode(node!), tag: node!.tag);

    var editor = Obx(() {
      return IgnorePointer(
        child: QuillEditor(
          controller: controller.quillController,
          focusNode: FocusNode(),
          readOnly: true,
          autoFocus: false,
          expands: false,
          padding: const EdgeInsets.only(top: 4),
          scrollController: ScrollController(),
          scrollable: false,
          customStyles: ConstList.getDefaultThemeData(context, scale,
              fontStyle:
              ConstList.getFont(vmDraggableNestedMap.mainFont.value)),
        ),
      );
    });

    var mainBox = Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            if (controller.imageString.value.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 3,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: PlatformSystem.getImage(controller.imageString.value),
                ),
              ),
            if (controller.titleString.value.isNotEmpty)
              TextOutline(
                controller.titleString.value,
                20 * scale,
                ConstList.getFont(vmDraggableNestedMap.titleFont.value),
              ),
          ],
        ),
        editor,
        if (vmDraggableNestedMap.isVisibleOnlyEdit()) ChoiceNodeSubDragTarget(node!),
        if (node!.children.isNotEmpty)
          ViewWrapCustom(
            node!.children,
            (child) => ViewChoiceNode.fromNode(child),
            maxSize: node!.width,
          )
      ],
    );

    var mainNode = Stack(
      alignment: Alignment.topCenter,
      children: [
        ColoredBox(
          color: controller.node.isCard
              ? Colors.white
              : getPlatform().colorBackground.lighten(),
          child: mainBox,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: isEditable
                ? InkWell(
                    onDoubleTap: () {
                      vmDraggableNestedMap.setEdit(node!);
                      Get.toNamed('/viewEditor', id: 1);
                    },
                  )
                : InkWell(
                    onTap: () async {
                      controller.select();
                      if (controller.isRandom.value) {
                        if (controller.isSelect()) {
                          controller.startRandom();
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
                    },
                  ),
          ),
        ),
        if (vmDraggableNestedMap.isVisibleOnlyEdit()) ...[
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
        ] else if (getPlatformFileSystem()
                .hasSource(controller.imageString.value) &&
            getPlatform().isVisibleSource) ...[
          Positioned(
            bottom: 0,
            left: 0,
            child: TextButton(
                child: const Text(
                  '출처',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
              ),
                onPressed: () {
                  var url = getPlatformFileSystem()
                      .getSource(controller.imageString.value);
                  if (url != null && url.isNotEmpty) {
                    launch(url);
                  }
                },
              ),
            ),
          ],
      ],
    );

    Widget innerWidget;
    if (isEditable) {
      innerWidget = mainNode;
    } else {
      innerWidget = Obx(
            () => IgnorePointer(
              ignoring: !controller.isIgnorePointer(),
          child: mainNode,
        ),
      );
    }

    return Obx(
          () {
        var isSelectedCheck = controller.status.value.isSelected() &&
            controller.node.isSelectable;
        return Opacity(
          opacity: controller.opacity,
          child: Card(
            shape: controller.isCardMode.value
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: isSelectedCheck
                          ? Colors.lightBlueAccent
                          : Colors.white,
                      width: 6,
                    ),
                  )
                : Border.fromBorderSide(
                    BorderSide(
                      color: isSelectedCheck
                          ? Colors.lightBlueAccent
                          : Colors.white,
                      width: 6,
                    ),
                  ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: controller.isCardMode.value ? ConstList.elevation : 0,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: innerWidget,
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
class ChoiceNodeSubDragTarget extends StatelessWidget {
  final ChoiceNodeBase node;
  const ChoiceNodeSubDragTarget(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmDraggableNestedMap = Get.find<VMDraggableNestedMap>();
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
            vmDraggableNestedMap.updateVMChoiceNode(node.pos());
          } else {
            var childNode = getPlatform().getChoiceNode(data)!;
            var parentLastPos = childNode.getParentLast()!.pos();
            childNode.parent!.removeChildren(childNode);
            node.addChildren(childNode);
            vmDraggableNestedMap.updateVMChoiceNode(parentLastPos);
            vmDraggableNestedMap.update();
          }
          getPlatform().checkDataCollect();
        },
      ),
      visible: vmDraggableNestedMap.drag != null &&
          vmDraggableNestedMap.drag != node.pos(),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
    );
  }
}

