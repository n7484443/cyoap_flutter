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
    final VMEditor _vmEditor = Get.put(VMEditor());
    if (ConstList.actualPlatformType == platformType.mobile) {
      return GetBuilder<VMEditor>(
        builder: (_) => Scaffold(
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
        ),
      );
    } else {
      return GetBuilder<VMEditor>(
        builder: (_) => Row(
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
                          _vmEditor.save();
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
        ),
      );
    }
  }
}

class ViewEditorTyping extends StatefulWidget {
  const ViewEditorTyping({Key? key}) : super(key: key);

  @override
  _ViewEditorTypingState createState() => _ViewEditorTypingState();
}

class _ViewEditorTypingState extends State<ViewEditorTyping> {
  final FocusNode _focusBody = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black12,
          child: TextField(
            controller: Get.find<VMEditor>().controllerTitle,
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
              controller: Get.find<VMEditor>().controllerBody,
              hideLink: true,
              hideQuote: true,
              hideListBullets: true,
              hideListNumbers: true,
              hideHorizontalRule: true,
              hideCodeBlock: true,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: OutlinedButton(
                child: Text('Edit Code'),
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
                    controller: Get.find<VMEditor>().controllerBody,
                    autofocus: true,
                    focusNode: _focusBody,
                    expands: true,
                  ),
                ),
              ),
              Visibility(
                child:
                    Positioned(top: 6, left: 5, child: Text('여기에 내용을 입력하세요')),
                visible: Get.find<VMEditor>().contents.value.isBlank ?? true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}