import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../viewModel/vm_code_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewCodeEditor extends StatelessWidget {
  const ViewCodeEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMCodeEditor vmCodeEditor = Get.put(VMCodeEditor());

    var leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => makePlatform.back(),
    );

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: leadingWidget,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                vmCodeEditor.save();
              },
            )
          ],
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Visibility(
                    visible: NodeEditor().target.isSelectableMode,
                    child: Focus(
                      onFocusChange: (bool hasFocus) => vmCodeEditor.lastFocus = vmCodeEditor.controllerClickable,
                      child: TextField(
                        controller: vmCodeEditor.controllerClickable,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(hintText: '실행 조건'),
                      ),
                    ),
                  ),
                  Focus(
                    onFocusChange: (bool hasFocus) => vmCodeEditor.lastFocus = vmCodeEditor.controllerVisible,
                    child: TextField(
                      controller: vmCodeEditor.controllerVisible,
                      textAlign: TextAlign.left,
                      decoration:
                          const InputDecoration(hintText: '보이는 조건(true일 때 보임, 비어있을 시 true)'),
                    ),
                  ),
                  Expanded(
                    child: Focus(
                      onFocusChange: (bool hasFocus) => vmCodeEditor.lastFocus = vmCodeEditor.controllerExecute,
                      child: TextField(
                        controller: vmCodeEditor.controllerExecute,
                        textAlign: TextAlign.left,
                        scrollController: ScrollController(),
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: '선택 시 시행 코드',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Obx(
                () => Column(
                  children: [
                    ViewSwitchLabel(
                      () => vmCodeEditor.isOccupySpace.toggle(),
                      vmCodeEditor.isOccupySpace.value,
                      label: '숨김 시 공간 차지',
                    ),
                  ],
                ),
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
