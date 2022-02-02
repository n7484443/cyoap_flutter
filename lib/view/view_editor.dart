import 'dart:ui';

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
    var appbarWidget = PreferredSize(
      preferredSize: Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(controller.isChanged){
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
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
                ),
              );
            }else{
              Get.back();
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '카드 모드',
              style: TextStyle(color: Colors.black),
            ),
            GetBuilder<VMEditor>(
              builder: (_) => Switch(
                onChanged: (bool value) {
                  controller.setCard(value);
                },
                value: controller.isCard,
              ),
            ),
          ],
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

    if (ConstList.actualPlatformType == platformType.mobile) {
      return Scaffold(
        appBar: appbarWidget,
        drawer: const ViewVariable(),
        body: const ViewEditorTyping(),
      );
    } else {
      return Row(
        children: [
          const ViewVariable(),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              appBar: appbarWidget,
              body: const ViewEditorTyping(),
            ),
          ),
        ],
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              quill.QuillToolbar.basic(
                controller: controller.controllerBody,
                showImageButton: false,
                showLink: false,
                showVideoButton: false,
                showCodeBlock: false,
                showListCheck: false,
              ),
              const Spacer(),
              OutlinedButton(
                child: const Text('Edit Code'),
                onPressed: () {
                  Get.toNamed('/viewCodeEditor');
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: quill.QuillEditor(
                  controller: controller.controllerBody,
                  readOnly: false,
                  expands: true,
                  focusNode: controller.focusBody,
                  scrollable: true,
                  scrollController: ScrollController(),
                  padding: const EdgeInsets.all(0.5),
                  autoFocus: false,
                  placeholder: '여기에 내용을 입력하세요',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    controller.addImage();
                  },
                  icon: const Icon(Icons.add)),
              Expanded(
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
            ],
          ),
        ),
      ],
    );
  }
}