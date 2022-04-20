import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../viewModel/vm_code_editor.dart';

class ViewCodeEditor extends StatelessWidget {
  const ViewCodeEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMCodeEditor _vmCodeEditor = Get.put(VMCodeEditor());

    var leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (_vmCodeEditor.isChanged) {
          showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
                  () => _vmCodeEditor.save(),
                  () => Get.back(id: 1),
              cancelFunction: () => _vmCodeEditor.isChanged = false,
            ),
          );
        } else {
          Get.back(id: 1);
        }
      },
    );

    var inputText = Column(
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
    );

    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(ConstList.appBarSize),
          child: AppBar(
            leading: leadingWidget,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _vmCodeEditor.save();
                },
              )
            ],
          ),
        ),
        body: inputText,
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => ViewBackDialog(
                () => _vmCodeEditor.save(),
                () => Get.back(id: 1),
            cancelFunction: () => _vmCodeEditor.isChanged = false,
          ),
        ) as Future<bool>;
      },
    );
  }
}
