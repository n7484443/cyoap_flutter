import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
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
      onPressed: () {
        if (vmCodeEditor.isChanged) {
          showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () => vmCodeEditor.save(),
              () => makePlatform.back(),
              cancelFunction: () => vmCodeEditor.isChanged = false,
            ),
          );
        } else {
          makePlatform.back();
        }
      },
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
                  TextField(
                    controller: vmCodeEditor.controllerClickable,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(hintText: '실행 조건'),
                    focusNode: vmCodeEditor.focusClickable,
                  ),
                  TextField(
                    controller: vmCodeEditor.controllerVisible,
                    textAlign: TextAlign.left,
                    decoration:
                        const InputDecoration(hintText: '숨김 조건(비어있을 시 항상 보임)'),
                    focusNode: vmCodeEditor.focusVisible,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: vmCodeEditor.focusExecute,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Obx(
                () => Column(
                  children: [
                    ViewSwitchLabel(
                      () => vmCodeEditor.isOccupySpace.value =
                          !vmCodeEditor.isOccupySpace.value,
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
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => ViewBackDialog(
            () => vmCodeEditor.save(),
            () => makePlatform.back(),
            cancelFunction: () => vmCodeEditor.isChanged = false,
          ),
        ) as Future<bool>;
      },
    );
  }
}
