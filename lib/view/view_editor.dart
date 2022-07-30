import 'dart:ui';

import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/design_setting.dart';
import '../model/image_db.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewEditor extends StatelessWidget {
  const ViewEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());

    var appbarWidget = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (!controller.controllerTitle.text.isBlank!) {
            makePlatform.back();
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            Get.find<VMEditor>().save();
          },
        ),
      ],
    );
    var highlightStyle = Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(color: Colors.blueAccent);
    var editingNodeValues = Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DropdownButton<ChoiceNodeMode>(
            value: controller.nodeMode.value,
            items: [
              DropdownMenuItem(
                  value: ChoiceNodeMode.defaultMode,
                  child: Text('기본', style: highlightStyle)),
              DropdownMenuItem(
                  value: ChoiceNodeMode.randomMode,
                  child: Text('랜덤 선택', style: highlightStyle)),
              DropdownMenuItem(
                  value: ChoiceNodeMode.multiSelect,
                  child: Text('다중 선택', style: highlightStyle)),
              DropdownMenuItem(
                  value: ChoiceNodeMode.unSelectableMode,
                  child: Text('선택 불가', style: highlightStyle)),
              DropdownMenuItem(
                  value: ChoiceNodeMode.onlyCode,
                  child: Text('코드만 사용', style: highlightStyle)),
            ],
            onChanged: (ChoiceNodeMode? value) {
              controller.nodeMode.value = value!;
            },
          ),
          Visibility(
            visible: controller.nodeMode.value == ChoiceNodeMode.randomMode,
            child: SizedBox(
              width: 120,
              child: Column(children: [
                Text('변수명',
                    style: ConstList.defaultFont.copyWith(fontSize: 20)),
                Text(
                    '${controller.controllerTitle.text.replaceAll(" ", "")}:random',
                    softWrap: true,
                    style: ConstList.defaultFont.copyWith(fontSize: 10)),
                TextField(
                  textAlign: TextAlign.end,
                  maxLength: 3,
                  minLines: 1,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  controller: controller.controllerMaximum,
                  decoration: const InputDecoration(
                    label: Text('랜덤 수, 0 ~ n-1'),
                  ),
                ),
              ]),
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value == ChoiceNodeMode.multiSelect,
            child: SizedBox(
              width: 120,
              child: Column(children: [
                Text('변수명',
                    style: ConstList.defaultFont.copyWith(fontSize: 20)),
                Text(
                    '${controller.controllerTitle.text.replaceAll(" ", "")}:multi',
                    softWrap: true,
                    style: ConstList.defaultFont.copyWith(fontSize: 10)),
                TextField(
                  textAlign: TextAlign.end,
                  maxLength: 3,
                  minLines: 1,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  controller: controller.controllerMaximum,
                  decoration: const InputDecoration(
                    label: Text('최대 선택'),
                  ),
                ),
              ]),
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value != ChoiceNodeMode.onlyCode,
            child: ViewSwitchLabel(
              () => controller.isCard.value = !controller.isCard.value,
              controller.isCard.value,
              label: '카드 모드',
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value != ChoiceNodeMode.onlyCode,
            child: ViewSwitchLabel(
              () => controller.isRound.value = !controller.isRound.value,
              controller.isRound.value,
              label: '외곽선 둥글게',
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value != ChoiceNodeMode.onlyCode,
            child: ViewSwitchLabel(
              () => controller.maximizingImage.value =
                  !controller.maximizingImage.value,
              controller.maximizingImage.value,
              label: '이미지 최대화',
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value != ChoiceNodeMode.onlyCode,
            child: ViewSwitchLabel(
              () => controller.hideTitle.value = !controller.hideTitle.value,
              controller.hideTitle.value,
              label: '제목 숨기기',
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value != ChoiceNodeMode.onlyCode,
            child: ViewSwitchLabel(
              () => controller.imagePosition.value =
                  (controller.imagePosition.value == 0) ? 1 : 0,
              controller.imagePosition.value != 0,
              label: '가로 모드',
            ),
          ),
          Visibility(
            visible: controller.nodeMode.value != ChoiceNodeMode.onlyCode,
            child: ViewSwitchLabel(
              () {
                if (controller.imagePosition.value == 1) {
                  controller.imagePosition.value = 2;
                } else if (controller.imagePosition.value == 2) {
                  controller.imagePosition.value = 1;
                }
              },
              controller.imagePosition.value == 2,
              disable: controller.imagePosition.value == 0,
              label: '이미지 왼쪽으로',
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: OutlinedButton(
              child: const Text('코드 수정'),
              onPressed: () {
                makePlatform.changePageString("viewCodeEditor");
              },
            ),
          ),
        ],
      ),
    );
    return WillPopScope(
      child: Scaffold(
        appBar: appbarWidget,
        body: Column(
          children: [
            TextField(
              controller: controller.controllerTitle,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '제목',
                hintStyle: titleFont.copyWith(fontSize: 24, color: Colors.red),
                filled: true,
              ),
              style: titleFont.copyWith(
                fontSize: 24,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => Visibility(
                          visible: controller.nodeMode.value !=
                              ChoiceNodeMode.onlyCode,
                          child: const ViewEditorTyping(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(ConstList.paddingSmall),
                    child: editingNodeValues,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        makePlatform.back();
        return false;
      },
    );
  }
}

class ViewEditorTyping extends StatelessWidget {
  const ViewEditorTyping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());

    void changeColor(QuillController controller, Color color, bool background) {
      var hex = color.value.toRadixString(16);
      if (hex.startsWith('ff')) {
        hex = hex.substring(2);
      }
      hex = '#$hex';
      controller.formatSelection(
          background ? BackgroundAttribute(hex) : ColorAttribute(hex));
    }

    void colorIconDialog(bool background) {
      Color newColor = const Color(0x00000000);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Color'),
          backgroundColor: Theme.of(context).canvasColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickersEnabled: {
                  ColorPickerType.both: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false
                },
                color: const Color(0x00000000),
                onColorChanged: (color) {
                  newColor = color;
                },
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Get.back();
              },
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                changeColor(controller.quillController, newColor, background);
                Get.back();
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuillToolbar.basic(
            controller: controller.quillController,
            showListCheck: false,
            showInlineCode: false,
            showVideoButton: false,
            showCameraButton: false,
            showImageButton: false,
            showLink: false,
            showCodeBlock: false,
            showHeaderStyle: false,
            showAlignmentButtons: true,
            showColorButton: false,
            showBackgroundColorButton: false,
            customButtons: [
              QuillCustomButton(
                icon: Icons.color_lens,
                onTap: () {
                  colorIconDialog(false);
                },
              ),
              QuillCustomButton(
                icon: Icons.format_color_fill,
                onTap: () {
                  colorIconDialog(true);
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: ConstList.elevation,
            child: QuillEditor(
              padding: const EdgeInsets.all(3),
              controller: controller.quillController,
              focusNode: FocusNode(),
              expands: true,
              scrollable: true,
              autoFocus: true,
              readOnly: false,
              showCursor: true,
              scrollController: ScrollController(),
              customStyles: ConstList.getDefaultThemeData(context, 1,
                  fontStyle: mainFont),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        var name = await controller.addImage();
                        if (name != '') {
                          controller.name = name;
                          await showDialog(
                            builder: (_) => AlertDialog(
                              title: const Text('출처'),
                              content: TextField(
                                controller: controller.controllerSource,
                                decoration: const InputDecoration(
                                  hintText: '출처를 모르거나 없을 경우 비워두세요.',
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    controller.addImageSource(name);
                                    Get.back();
                                  },
                                  child: const Text('자르기'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.addImageSource(name);
                                    controller
                                        .addImageCrop(controller.imageLast!);
                                    Get.back();
                                  },
                                  child: const Text('저장하기'),
                                ),
                              ],
                            ),
                            context: context,
                          );
                          if (controller.imageLast != null) {
                            makePlatform.changePageString('viewImageEditor');
                          }
                        }
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
              Expanded(
                child: Card(
                  elevation: ConstList.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      }),
                      child: GetBuilder<VMEditor>(
                        builder: (_) => ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: ScrollController(),
                          itemCount: controller.getImageLength(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: index == controller.index
                                      ? Colors.redAccent
                                      : Colors.white,
                                ),
                              ),
                              child: GestureDetector(
                                child: ViewImageLoading(
                                    ImageDB().getImageName(index)),
                                onDoubleTap: () {
                                  controller.setIndex(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
