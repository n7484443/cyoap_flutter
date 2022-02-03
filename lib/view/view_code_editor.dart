import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../viewModel/vm_code_editor.dart';

class ViewCodeEditor extends StatelessWidget {
  const ViewCodeEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMCodeEditor _vmCodeEditor = Get.put(VMCodeEditor());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ConstList.appBarSize),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if(_vmCodeEditor.isChanged){
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('뒤로가기'),
                    content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          _vmCodeEditor.isChanged = false;
                          Get.back();
                          Get.back();
                        },
                        child: const Text('아니오'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _vmCodeEditor.save();
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
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Get.find<VMCodeEditor>().save();
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _vmCodeEditor.controllerClickable,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: '실행 조건'),
          ),
          TextField(
            controller: _vmCodeEditor.controllerVisible,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: '숨김 조건(비어있을 시 항상 보임)'),
          ),
          Expanded(
            child: TextField(
              controller: _vmCodeEditor.controllerExecute,
              textAlign: TextAlign.center,
              scrollController: ScrollController(),
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                  hintText: '선택 시 시행 코드',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
