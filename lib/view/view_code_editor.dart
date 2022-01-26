import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

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
        child: AppBar(),
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
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                  hintText: '선택 시 시행 코드',
              ),
            ),
          ),
        ],
      ),
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
  }
}
