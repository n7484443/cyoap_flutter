import 'dart:ui';

import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

import '../main.dart';
import '../viewModel/vm_editor.dart';

class ViewEditor extends StatelessWidget {
  const ViewEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());

    var alert = AlertDialog(
      title: const Text('뒤로가기'),
      content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            controller.isChanged = false;
            Get.back();
            Get.back();
          },
          child: const Text('아니오'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.isChanged = false;
            controller.save();
            Get.back();
            Get.back();
          },
          child: const Text('예'),
        ),
      ],
    );

    var appbarWidget = PreferredSize(
      preferredSize: Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(controller.isChanged){
              showDialog(
                context: context,
                builder: (_) => alert,
              );
            }else{
              Get.back();
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
      ),
    );

    var editingNodeValues = SizedBox(
      child: GetBuilder<VMEditor>(
        builder: (_) => Column(
          children: [
            Row(
              children: [
                const Text(
                  '카드 모드',
                  style: TextStyle(color: Colors.black),
                ),
                Switch(
                  onChanged: (bool value) {
                    controller.setCard(value);
                  },
                  value: controller.isCard,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '선택 가능',
                  style: TextStyle(color: Colors.black),
                ),
                Switch(
                  onChanged: (bool value) {
                    controller.setSelectable(value);
                  },
                  value: controller.isSelectable,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        child: Scaffold(
          appBar: appbarWidget,
          drawer: const ViewVariable(),
          body: Column(
            children: [
              Container(
                color: Colors.black12,
                child: TextField(
                  controller: controller.controllerTitle,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: '제목'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
        onWillPop: (){
          return showDialog(
            context: context,
            builder: (_) => alert,
          ) as Future<bool>;
        },
      );
    } else {
      return Scaffold(
        appBar: appbarWidget,
        body: Row(
          children: [
            const ViewVariable(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Colors.black12,
                    child: TextField(
                      controller: controller.controllerTitle,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(hintText: '제목'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
          ],
        ),
      );
    }
  }
}

class ViewEditorTyping extends StatelessWidget {
  const ViewEditorTyping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: quill.QuillToolbar.basic(
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
          ),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: 5.0,
            child: quill.QuillEditor(
              padding: const EdgeInsets.all(3),
              controller: controller.quillController,
              focusNode: FocusNode(),
              expands: true,
              scrollable: true,
              autoFocus: false,
              readOnly: false,
              scrollController: ScrollController(),
              customStyles: ConstList.getDefaultThemeData(context, 1, fontStyle: ConstList.getFont(PlatformSystem.getPlatform().mainFont)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                child: const Text('Edit Code'),
                onPressed: () {
                  Get.toNamed('/viewCodeEditor');
                },
              ),
              const SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: '포인트 증감'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        controller.addImage();
                      },
                      icon: const Icon(Icons.add)),
                  GetBuilder<VMEditor>(
                    builder: (_) => Visibility(
                      child: const CircularProgressIndicator(),
                      visible: controller.isConvertImage,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(4.0, 4.0),
                        color: Colors.black38,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: ScrollConfiguration(
                    behavior:
                        ScrollConfiguration.of(context).copyWith(dragDevices: {
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
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: index == controller.index
                                      ? Colors.redAccent
                                      : Colors.white,
                                ),
                              ),
                              child: GestureDetector(
                                child: Image.memory(controller.getImage(index)),
                                onDoubleTap: () {
                                  controller.setImage(index);
                                },
                              ),
                            ),
                          );
                        },
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