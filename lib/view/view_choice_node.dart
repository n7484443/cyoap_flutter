import 'package:cyoap_flutter/util/color_util.dart';
import 'package:cyoap_flutter/view/view_text_outline.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/platform_system.dart';

class ViewChoiceNode extends StatelessWidget {
  final int posX;
  final int posY;

  const ViewChoiceNode(
      {Key? key, required this.posX, required this.posY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VMChoiceNode(x: posX, y: posY),
        tag: VMChoiceNode.getTag(posX, posY));
    var vmDraggableNestedMap = Get.find<VMDraggableNestedMap>();
    var scale = vmDraggableNestedMap.getScale();

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
                fontStyle: ConstList.getFont(vmDraggableNestedMap.mainFont.value)),
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
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child:
                      PlatformSystem.getImage(controller.imageString.value),
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
              child: TextOutline(controller.titleString.value,
                      18 * scale.data2,  ConstList.getFont(vmDraggableNestedMap.titleFont.value)),
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

    var mainNode = Obx(
      () => Container(
        padding: const EdgeInsets.all(6),
        width: controller.realSize.value.data1 * scale.data1,
        height: controller.realSize.value.data2 * scale.data2,
        color: controller.node.isCard
            ? null
            : getPlatform().colorBackground.lighten(),
        child: Column(
          children: [
            Expanded(child: image),
            editor,
          ],
        ),
      ),
    );
    Widget innerWidget;
    if (isEditable()) {
      innerWidget = InkWell(
        onDoubleTap: () {
          vmDraggableNestedMap.setEdit(posX, posY);
          Get.toNamed('/viewEditor', id: 1);
        },
        child: mainNode,
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
          return Opacity(
            opacity: isEditable() || controller.isIgnorePointer()
                ? 1.0
                : 0.5,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: controller.status.value.isSelected() &&
                          controller.node.isSelectable
                      ? Colors.lightBlueAccent
                      : Colors.white,
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
          opacity:
              isEditable() || controller.status.value.isSelected() ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: controller.status.value.isSelected() &&
                          controller.node.isSelectable
                      ? Colors.lightBlueAccent
                      : Colors.white,
                  width: 6),
              color: Colors.white,
            ),
            child: innerWidget,
          ),
        );
      },
    );
  }
}