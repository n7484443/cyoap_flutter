import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_text_outline.dart';
import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_variable_table.dart';

class ViewChoiceNode extends GetView<VMDraggableNestedMap> {
  final ChoiceNode? node;

  ViewChoiceNode(int posX, int posY, {Key? key})
      : node = posX < 0 && posY < 0
            ? null
            : getPlatform.getChoiceNode([posY, posX])!,
        super(key: key);

  const ViewChoiceNode.fromNode(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (node == null) {
      return Card(
        child: SizedBox(
          width: controller.maxWidth /
              defaultMaxSize *
              3 *
              controller.scale(context),
          height: nodeBaseHeight * controller.scale(context),
        ),
      );
    }
    var nodeController = Get.put(VMChoiceNode.fromNode(node!), tag: node!.tag);

    return Obx(
      () {
        var isSelectedCheck = nodeController.node.isSelected() &&
            nodeController.node.isSelectable;
        return Opacity(
          opacity: nodeController.opacity,
          child: Card(
            shape: nodeController.isRound.value
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: isSelectedCheck
                          ? Colors.lightBlueAccent
                          : Get.find<VMDesignSetting>().colorNode.value,
                      width: ConstList.isSmallDisplay(context) ? 2 : 4,
                    ),
                  )
                : Border.fromBorderSide(
                    BorderSide(
                      color: isSelectedCheck
                          ? Colors.lightBlueAccent
                          : Get.find<VMDesignSetting>().colorNode.value,
                      width: ConstList.isSmallDisplay(context) ? 2 : 4,
                    ),
                  ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: ConstList.isSmallDisplay(context)
                ? const EdgeInsets.all(1.4)
                : null,
            elevation: nodeController.isCard.value ? ConstList.elevation : 0,
            color: Get.find<VMDesignSetting>().colorNode.value,
            child: Ink(
              color: Get.find<VMDesignSetting>().colorNode.value,
              child: Padding(
                padding: ConstList.isSmallDisplay(context)
                    ? const EdgeInsets.all(2.0)
                    : const EdgeInsets.all(4.0),
                child: InkWell(
                  onDoubleTap: isEditable
                      ? () {
                          controller.editNode = node!;
                          makePlatform.changePageString("viewEditor");
                        }
                      : null,
                  onTap: !isEditable &&
                          (nodeController.nodeMode.value !=
                                  ChoiceNodeMode.multiSelect ||
                              nodeController.isIgnorePointer)
                      ? () => nodeController.select(0, context)
                      : null,
                  child: ViewChoiceNodeContent(node!.tag, controller),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SizeDialog extends GetView<VMChoiceNode> {
  final String _tag;

  @override
  get tag => _tag;

  const SizeDialog(this._tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      title: const Text('크기 수정', textAlign: TextAlign.center),
      content: SizedBox(
        width: 400,
        height: 100,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '길이 : ${controller.size.value == 0 ? 'max' : controller.size.value.toString()}',
                  style: const TextStyle(fontSize: 16)),
              Slider(
                onChanged: (double value) {
                  controller.sizeChange(value.round());
                },
                value: controller.size.value.toDouble(),
                divisions: defaultMaxSize,
                max: defaultMaxSize.toDouble(),
                min: 0,
                label: controller.size.value == 0
                    ? 'max'
                    : controller.size.value.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RandomDialog extends StatelessWidget {
  final ChoiceNode? node;

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
            Visibility(
              visible: !controller.randomProcess.value,
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

class NodeDraggable extends GetView<VMDraggableNestedMap> {
  final ChoiceNode node;

  const NodeDraggable(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widget = ViewChoiceNode.fromNode(node);
    var pos = node.pos();
    if (GetPlatform.isMobile) {
      return LongPressDraggable<List<int>>(
        onDragUpdate: (details) => controller.dragUpdate(details, context),
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
        child: listEquals(controller.drag, pos)
            ? Opacity(
                opacity: 0.2,
                child: widget,
              )
            : widget,
        onDragEnd: (DraggableDetails data) {
          controller.dragEnd();
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          controller.dragEnd();
        },
      );
    } else {
      return Draggable<List<int>>(
        onDragUpdate: (details) => controller.dragUpdate(details, context),
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
          opacity: listEquals(controller.drag, pos) ? 0.2 : 1.0,
          child: widget,
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

class ViewTitleWithEdit extends GetView<VMChoiceNode> {
  final String _tag;
  final VMDraggableNestedMap draggableController;

  @override
  String? get tag => _tag;

  const ViewTitleWithEdit(this._tag, this.draggableController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutSetting = Get.find<VMDesignSetting>();
    Widget title = Obx(() {
      if (!controller.hideTitle.value) {
        if (layoutSetting.titleOutline.value) {
          return TextOutline(
            controller.titleString.value,
            20 * draggableController.scale(context),
            ConstList.getFont(layoutSetting.titleFont.value),
          );
        }
        return Text(
          controller.titleString.value,
          style: ConstList.getFont(layoutSetting.titleFont.value).copyWith(
            fontSize: 20 * draggableController.scale(context),
            color: layoutSetting.colorNode.value.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
        );
      }
      return const SizedBox.shrink();
    });
    if (!isEditable) {
      return title;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        title,
        Align(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (result) {
              switch (result) {
                case 0:
                  showDialog(
                    context: context,
                    builder: (builder) => SizeDialog(_tag),
                  );
                  break;
                case 1:
                  Get.find<VMDraggableNestedMap>().copyData(controller.node);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('크기 수정'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('복사'),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}

class ViewChoiceNodeMultiSelect extends GetView<VMChoiceNode> {
  final String _tag;

  @override
  String? get tag => _tag;

  const ViewChoiceNodeMultiSelect(this._tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 30),
            onPressed: () {
              if (!isEditable) {
                controller.select(-1, context);
              }
            },
          ),
        ),
        Expanded(
          child: Obx(
            () => Text(
              controller.selectedMultiple.toString(),
              style: ConstList.defaultFont.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.chevron_right, size: 30),
            onPressed: () {
              if (!isEditable) {
                controller.select(1, context);
              }
            },
          ),
        ),
      ],
    );
  }
}

class ViewChoiceNodeContent extends GetView<VMChoiceNode> {
  final VMDraggableNestedMap draggableController;
  final String _tag;

  @override
  String? get tag => _tag;

  const ViewChoiceNodeContent(this._tag, this.draggableController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutSetting = Get.find<VMDesignSetting>();
    Widget image = Obx(() {
      if (controller.imageString.value.isNotEmpty) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: controller.maximizingImage.value
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height / 2,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: ViewImageLoading(controller.imageString.value),
          ),
        );
      }
      return const SizedBox.shrink();
    });

    Widget title = ViewTitleWithEdit(_tag, draggableController);

    Widget contents;
    if (controller.quillController.document.isEmpty()) {
      if (controller.node.choiceNodeMode == ChoiceNodeMode.multiSelect) {
        contents = ViewChoiceNodeMultiSelect(_tag);
      } else {
        contents = const SizedBox.shrink();
      }
    } else {
      Widget contentText = IgnorePointer(
        child: QuillEditor(
          controller: controller.quillController,
          focusNode: FocusNode(),
          readOnly: true,
          autoFocus: false,
          expands: false,
          padding: const EdgeInsets.only(top: 4),
          scrollController: ScrollController(),
          scrollable: false,
          customStyles: ConstList.getDefaultThemeData(
              context, draggableController.scale(context),
              fontStyle: ConstList.getFont(layoutSetting.mainFont.value)),
        ),
      );
      if (controller.node.choiceNodeMode == ChoiceNodeMode.multiSelect) {
        contents = Column(children: [
          contentText,
          ViewChoiceNodeMultiSelect(_tag),
        ]);
      } else {
        contents = contentText;
      }
    }

    Widget out = Obx(() {
      Widget? child;
      if (isEditable) {
        child = ViewWrapCustomReorderable(
          controller.node.children,
          (child) => NodeDraggable(child),
          maxSize: controller.node.getMaxSize(true),
          builderDraggable: (i) => NodeDragTarget(
              List.from(controller.node.pos(), growable: true)..add(i)),
        );
      } else if (controller.node.children.isNotEmpty) {
        child = ViewWrapCustom(
          controller.node.children,
          (child) => ViewChoiceNode.fromNode(child),
          maxSize: controller.node.getMaxSize(true),
        );
      }
      if (controller.imagePosition.value == 1) {
        return Column(
          children: [
            title,
            Row(
              children: [
                Flexible(
                  child: contents,
                ),
                Expanded(child: image),
              ],
            ),
            if (child != null) child,
          ],
        );
      }
      if (controller.imagePosition.value == 2) {
        return Column(
          children: [
            title,
            Row(
              children: [
                Expanded(child: image),
                Flexible(
                  child: contents,
                ),
              ],
            ),
            if (child != null) child,
          ],
        );
      }
      List<Widget> subWidget;
      if (layoutSetting.titleOverlap.value) {
        subWidget = [
          Stack(
            alignment: layoutSetting.titlePosition.value
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            children: [
              image,
              title,
            ],
          ),
        ];
      } else if (layoutSetting.titlePosition.value) {
        subWidget = [
          title,
          image,
        ];
      } else {
        subWidget = [
          image,
          title,
        ];
      }

      subWidget.addAll([
        contents,
        if (child != null) child,
      ]);

      if (!isEditable &&
          getPlatformFileSystem.hasSource(controller.imageString.value) &&
          Get.find<VMVariableTable>().isVisibleSource.value) {
        subWidget.add(
          TextButton(
            child: const Text(
              '출처',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
            ),
            onPressed: () {
              var url =
                  getPlatformFileSystem.getSource(controller.imageString.value);
              if (url != null && url.isNotEmpty) {
                launchUrlString(url);
              }
            },
          ),
        );
      }
      return Column(
        children: subWidget,
      );
    });
    return out;
  }
}
