import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/generable_parser.dart';
import 'package:cyoap_flutter/util/color_util.dart';
import 'package:cyoap_flutter/view/view_text_outline.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';

class ViewChoiceNode extends StatelessWidget {
  final ChoiceNodeBase? node;

  ViewChoiceNode(int posX, int posY, {Key? key})
      : node = posX == nonPositioned && posY == nonPositioned
            ? null
            : getPlatform().getChoiceNode(posX, posY)!,
        super(key: key);

  const ViewChoiceNode.fromNode(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmDraggableNestedMap = Get.find<VMDraggableNestedMap>();
    var scale = vmDraggableNestedMap.getScale();
    if (node == null) {
      return Card(
        child: SizedBox(
          width: nodeBaseWidth * scale.data1,
          height: nodeBaseHeight * 10 * scale.data2,
        ),
      );
    }
    var controller = Get.put(
        VMChoiceNode.fromNode(node!),
        tag: VMChoiceNode.getTag(node!));

    var editor = Obx(() {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: controller.realSize.value.data2 * scale.data2 - 45,
        ),
        child: IgnorePointer(
          child: QuillEditor(
            controller: controller.quillController,
            focusNode: FocusNode(),
            readOnly: true,
            autoFocus: false,
            expands: false,
            padding: const EdgeInsets.only(top: 4),
            scrollController: ScrollController(),
            scrollable: false,
            customStyles: ConstList.getDefaultThemeData(context, scale.data2,
                fontStyle:
                ConstList.getFont(vmDraggableNestedMap.mainFont.value)),
          ),
        ),
      );
    });

    var sizeDialog = AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      title: const Text('크기 수정'),
      content: Obx(
            () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('길이'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      controller.sizeChange(-1, 0);
                    },
                  ),
                  Text(
                      '${controller.size.value.data1 == 0 ? 'max' : controller.size.value.data1}'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      controller.sizeChange(1, 0);
                    },
                  ),
                ],
              ),
              const Text('높이'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: IconButton(
                      icon: const Icon(
                        Icons.double_arrow,
                      ),
                      onPressed: () {
                        controller.sizeChange(0, -5);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      controller.sizeChange(0, -1);
                    },
                  ),
                  Text('${controller.size.value.data2 / 10}'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      controller.sizeChange(0, 1);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.double_arrow,
                    ),
                    onPressed: () {
                      controller.sizeChange(0, 5);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

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
                20 * scale.data2,
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
                      builder: (builder) => sizeDialog,
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

    var childList = List<Widget>.empty(growable: true);
    for (var nodeChild in node!.children) {
      childList.add(ViewChoiceNode.fromNode(nodeChild as ChoiceNodeBase));
    }

    var mainNode = Obx(
      () => Container(
        padding: const EdgeInsets.all(6),
        width: controller.realSize.value.data1 * scale.data1,
        height: controller.realSize.value.data2 * scale.data2,
        color: controller.node.isCard
            ? null
            : getPlatform().colorBackground.lighten(),
        child: Column(
          children: List.generate(
            childList.length + 2,
            (index) {
              switch (index) {
                case 0:
                  return Expanded(child: image);
                case 1:
                  return editor;
                default:
                  return Expanded(
                    child: childList[index - 2],
                  );
              }
            },
          ),
        ),
          ),
    );

    Widget innerWidget;
    if (isEditable()) {
      innerWidget = InkWell(
        onDoubleTap: () {
          vmDraggableNestedMap.setEdit(
              node!.currentPos, node!.parent!.currentPos);
          Get.toNamed('/viewEditor', id: 1);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            mainNode,
            Visibility(
              child: DragTarget(
                builder: (BuildContext context, List<Object?> candidateData,
                    List<dynamic> rejectedData) =>
                    Container(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: controller.realSize.value.data1 * scale.data1 * 0.6,
                      height: controller.realSize.value.data2 * scale.data2 * 0.6,
                    ),
                onAccept: (Tuple<int, int> data) {
                  if (data == Tuple(nonPositioned, nonPositioned)) {
                    node!.addChildren(VMDraggableNestedMap.createNodeForTemp());
                  } else {
                    var childNode =
                        getPlatform().getChoiceNode(data.data1, data.data2)!;
                    node!.addChildren(childNode);
                    node!.parent!.removeChildren(node!);
                  }
                  //TODO
                },
              ),
              visible: vmDraggableNestedMap.drag !=
                      Tuple(node!.currentPos, node!.parent!.currentPos) &&
                  vmDraggableNestedMap.drag != null,
            ),
          ],
        ),
      );
    } else {
      innerWidget = Obx(
            () => IgnorePointer(
          ignoring: !controller.isIgnorePointer(),
          child: InkWell(
            onTap: () {
              controller.select();
            },
            child: mainNode,
          ),
        ),
      );
    }

    return Obx(
          () {
        if (controller.isCardMode.value) {
          var isSelectedCheck = controller.status.value.isSelected() &&
              controller.node.isSelectable;
          return Opacity(
            opacity: controller.opacity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color:
                      isSelectedCheck ? Colors.lightBlueAccent : Colors.white,
                  width: 6,
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: ConstList.elevation,
              child: innerWidget,
            ),
          );
        }
        return Opacity(
          opacity: controller.opacity,
          child: innerWidget,
        );
      },
    );
  }
}
