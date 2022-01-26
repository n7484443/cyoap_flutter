import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

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
                child: AppBar(),
              ),
              body: const ViewEditorTyping(),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        Get.find<VMEditor>().save();
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
        Row(
          children: [
            ZefyrToolbar.basic(
              controller: controller.controllerBody,
              hideLink: true,
              hideQuote: true,
              hideListBullets: true,
              hideListNumbers: true,
              hideHorizontalRule: true,
              hideCodeBlock: true,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: OutlinedButton(
                child: const Text('Edit Code'),
                onPressed: () {
                  Get.toNamed('/viewCodeEditor');
                },
              ),
            )
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ZefyrEditor(
                    controller: controller.controllerBody,
                    autofocus: true,
                    focusNode: controller.focusBody,
                    expands: true,
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  child: const Positioned(
                      top: 10, left: 5, child: Text('여기에 내용을 입력하세요')),
                  visible: controller.contents.value.isBlank ?? true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}