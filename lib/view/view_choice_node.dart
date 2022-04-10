import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/generable_parser.dart';
import 'package:cyoap_flutter/util/color_util.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
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
          width: nodeBaseWidth * scale,
          height: nodeBaseHeight * 10,
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

    var image = Obx(
          () => Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Visibility(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: PlatformSystem.getImage(controller.imageString.value),
                ),
              ),
              visible: controller.imageString.value.isNotEmpty,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Visibility(
              child: TextButton(
                child: const Text('출처'),
                onPressed: () {
                  var url = getPlatformFileSystem()
                      .getSource(controller.imageString.value);
                  if (url != null && url.isNotEmpty) {
                    launch(url);
                  }
                },
              ),
              visible: getPlatformFileSystem()
                      .hasSource(controller.imageString.value) &&
                  getPlatform().isVisibleSource,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Visibility(
              child: TextOutline(
                controller.titleString.value,
                20 * scale,
                ConstList.getFont(vmDraggableNestedMap.titleFont.value),
              ),
              visible: controller.titleString.value.isNotEmpty,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
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
              visible: VMDraggableNestedMap.isVisibleOnlyEdit(),
            ),
          ),
        ],
      ),
    );

    var dragTarget = Visibility(
      child: DragTarget(
        builder: (BuildContext context, List<Object?> candidateData,
                List<dynamic> rejectedData) =>
            Container(
          color: Colors.blueAccent.withOpacity(0.3),
          height: 20,
        ),
        onAccept: (List<int> data) {
          if (data[data.length - 1] == nonPositioned) {
            node!.addChildren(VMDraggableNestedMap.createNodeForTemp());
            vmDraggableNestedMap.updateVMChoiceNode(node!.pos());
          } else {
            var childNode = getPlatform().getChoiceNode(data)!;
            var parentLastPos = childNode.getParentLast()!.pos();
            childNode.parent!.removeChildren(childNode);
            node!.addChildren(childNode);
            vmDraggableNestedMap.updateVMChoiceNode(parentLastPos);
            vmDraggableNestedMap.update();
          }
          getPlatform().checkDataCollect();
          //TODO
        },
      ),
      visible: vmDraggableNestedMap.drag != null &&
          vmDraggableNestedMap.drag != node?.pos(),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
    );

    Widget? childColumn;
    if(node!.children.isNotEmpty){
      List<List<Widget>> widget = List.filled(
          1, List<Widget>.empty(growable: true),
          growable: true);

      int inner = 0;
      for (int i = 0; i < node!.children.length; i++) {
        var child = node!.children[i] as ChoiceNodeBase;
        var size = child.width == 0 ? node!.width : child.width;
        if (inner + size > node!.width) {
          widget.last.add(Flexible(
              flex: node!.width - inner, child: const SizedBox.shrink()));
          widget.add(List<Widget>.empty(growable: true));
          inner = size;
        } else {
          inner += size;
        }
        widget.last
            .add(Flexible(flex: size, child: ViewChoiceNode.fromNode(child)));
      }
      if (inner != node!.width) {
        widget.last.add(Flexible(
            flex: node!.width - inner, child: const SizedBox.shrink()));
      }
      childColumn = Column(
        children: widget
            .map(
              (e) => Row(
              children: e,
          ),
        ).toList(),
      );
    }


    var mainNode = Container(
      padding: const EdgeInsets.all(6),
      color: controller.node.isCard
          ? null
          : getPlatform().colorBackground.lighten(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          node!.children.isEmpty ? 3 : 4,
          (index) {
            switch (index) {
              case 0:
                return image;
              case 1:
                return editor;
              case 2:
                return dragTarget;
              default:
                return Expanded(
                    child: childColumn!,
                );
            }
          },
            ),
          ),
    );

    Widget innerWidget;
    if (isEditable()) {
      innerWidget = InkWell(
        onDoubleTap: () {
          vmDraggableNestedMap.setEdit(node!);
          Get.toNamed('/viewEditor', id: 1);
        },
        child: mainNode,
      );
    } else {
      innerWidget = Obx(
            () => IgnorePointer(
          ignoring: !controller.isIgnorePointer(),
          child: InkWell(
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
            child: mainNode,
          ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: isSelectedCheck ? Colors.lightBlueAccent : Colors.white,
                width: 6,
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: controller.isCardMode.value ? ConstList.elevation : 0,
            child: innerWidget,
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
