import 'dart:ui';

import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';

import '../main.dart';
import '../model/image_db.dart';
import '../model/design_setting.dart';
import '../viewModel/vm_editor.dart';

class ViewEditor extends StatelessWidget {
  const ViewEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());

    var appbarWidget = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (controller.title.value.trim().isNotEmpty) {
            if (controller.isChanged) {
              showDialog(
                context: context,
                builder: (_) => ViewBackDialog(
                  () => controller.save(),
                  () => Get.back(id: 1),
                  cancelFunction: () => controller.isChanged = false,
                ),
              );
            } else {
              Get.back(id: 1);
            }
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

    var editingNodeValues = Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ViewSwitchLabel(
            () => controller.isCard.value = !controller.isCard.value,
            controller.isCard.value,
            label: '카드 모드',
          ),
          ViewSwitchLabel(
            () => controller.isRound.value = !controller.isRound.value,
            controller.isRound.value,
            label: '외곽선 둥글게',
          ),
          ViewSwitchLabel(
            () =>
                controller.isSelectable.value = !controller.isSelectable.value,
            controller.isSelectable.value,
            label: '선택 가능',
          ),
          ViewSwitchLabel(
            () => controller.isRandom.value = !controller.isRandom.value,
            controller.isRandom.value,
            label: '랜덤 기능',
          ),
          Visibility(
            visible: controller.isRandom.value,
            child: SizedBox(
              width: 80,
              child: TextField(
                textAlign: TextAlign.end,
                maxLength: 3,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: controller.controllerRandom,
                decoration: const InputDecoration(
                  label: Text('랜덤 범위'),
                ),
              ),
            ),
          ),
          ViewSwitchLabel(
            () => controller.maximizingImage.value =
                !controller.maximizingImage.value,
            controller.maximizingImage.value,
            label: '이미지 최대화',
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: OutlinedButton(
              child: const Text('코드 수정'),
              onPressed: () {
                Get.toNamed('/viewCodeEditor', id: 1);
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
            Obx(() => TextField(
                  controller: controller.controllerTitle,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: controller.title.value.trim().isEmpty
                        ? Colors.redAccent
                        : null,
                    hintText: '제목',
                    hintStyle: titleFont.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                    filled: true,
                  ),
                  style: titleFont.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )),
            Expanded(
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ViewEditorTyping(),
                    ),
                  ),
                  editingNodeValues,
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        if (controller.title.value.trim().isNotEmpty) {
          return await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () => controller.save(),
              () => Get.back(id: 1),
              cancelFunction: () => controller.isChanged = false,
            ),
          );
        }
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
            customIcons: [
              QuillCustomIcon(
                icon: Icons.color_lens,
                onTap: () {
                  colorIconDialog(false);
                },
              ),
              QuillCustomIcon(
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
              autoFocus: false,
              readOnly: false,
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
                            Get.toNamed('/viewImageEditor', id: 1);
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
