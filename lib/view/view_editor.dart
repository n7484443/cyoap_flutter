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
    if (ConstList.actualPlatformType == platformType.mobile) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ConstList.appBarSize),
          child: AppBar(),
        ),
        drawer: const ViewVariable(),
        body: const ViewEditorTyping(),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Get.back();
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  Get.back();
                },
              ),
              ],
            ),
          ),
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
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(ConstList.appBarSize),
                child: AppBar(
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        Get.find<VMEditor>().save();
                      },
                    ),
                  ],
                ),
              ),
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
      ],
    );
  }
}